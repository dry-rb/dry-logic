# frozen_string_literal: true

require "dry/core/constants"

require "dry/logic/rule"
require "dry/logic/rule/predicate"

require "dry/logic/rule_compiler"

module Dry
  module Logic
    class RuleInterpreter
      include Core::Constants

      BINARY_OPS = {
        'AND'  => :and,
        'XOR'  => :xor,
        'OR'   => :or,
        'THEN' => :implication
      }

      PATTERNS = {
        :binary_op => Regexp.new("\\s+(?:#{Regexp.union(BINARY_OPS.keys).source})\\s+"),
        :check_op  => /\Acheck\[(.+)\]\((.+)\)/,
        :key_op    => /\A(attr|key)\[(.+)\]\((.+)\)/,
        :unary_op  => /\A(\w+(?!\?))\((.+)\)/,
        :predicate => /\A(\w+\?)(\((.+)\))?/
      }

      attr_reader :predicates

      def initialize(predicates)
        @predicates = predicates
      end

      def compiler
        @compiler ||= RuleCompiler.new(@predicates)
      end

      def compile(string)
        ast = call(string)
        ast = [ast] unless ast[0].is_a?(Array)
        compiler.(ast)
      end

      def call(*rules)
        rules.map do |rule|
          case rule
          when String
            read_with_patterns(rule) || eval_string(rule)
          else
            rule
          end
        end
      end

      def read_with_patterns(rule)
        PATTERNS.inject(nil) do |a, (key, pattern)|
          a || pattern.match(rule) { |m| visit(key, m) }
        end
      end

      def visit(key, m)
        send(:"visit_#{key}", m)
      end

      def visit_binary_op(m)
        op = m[0].strip
        [BINARY_OPS.fetch(op), call(m.pre_match, m.post_match)]
      end

      def visit_unary_op(m)
        visit(m[1].to_sym, m[2])
      end

      def visit_each(string)
        [:each, *call(string)]
      end

      def visit_set(string)
        [:set, call(string)]
      end

      def visit_not(string)
        [:not, *call(string)]
      end

      def visit_key_op(m)
        [m[1].to_sym, call(*m.values_at(2, 3))]
      end

      def visit_check_op(m)
        [:check, [m[1].split(",").map(&:to_sym), *call(m[2])]]
      end

      def visit_predicate_params(name, args)
        params = Predicates[name].parameters.map(&:last)
        params.map.with_index { |name, idx| [name, args.fetch(idx, Undefined)] }
      end

      def visit_predicate(m)
        name = m[1].to_sym
        args = m[2] ? m[3].split(',').flat_map { |v| call(v) } : EMPTY_ARRAY
        [:predicate, [name, visit_predicate_params(name, args)]]
      end

      def eval_string(rule)
        eval(rule)
      rescue NameError
        rule.to_sym
      end
    end
  end
end