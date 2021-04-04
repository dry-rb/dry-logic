# frozen_string_literal: true

require "dry/core/constants"

require "dry/logic/rule"
require "dry/logic/rule/predicate"

require "dry/logic/rule_compiler"

module Dry
  module Logic
    class RuleInterpreter
      include Core::Constants

      BINARY_OPS = { "AND" => :and, "XOR" => :xor, "OR" => :or, "THEN" => :implication }.freeze

      PATTERNS = {
        binary_op: Regexp.new("\\s+(?:#{Regexp.union(BINARY_OPS.keys).source})\s+"),
         check_op: /\Acheck\[(.+)\]\((.+)\)/,
           key_op: /\A(attr|key)\[(.+)\]\((.+)\)/,
         unary_op: /\A(\w+(?!\?))\((.+)\)/,
        predicate: /\A(\w+\?)(\((.+)\))?/
      }.freeze

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
        PATTERNS.inject(nil) do |matched, (key, pattern)|
          matched || pattern.match(rule) { |match| visit(key, match) }
        end
      end

      def visit(key, arg)
        send(:"visit_#{key}", arg)
      end

      def visit_binary_op(match)
        operator = match[0].strip
        [BINARY_OPS.fetch(operator), call(match.pre_match, match.post_match)]
      end

      def visit_unary_op(match)
        case operation = match[1].to_sym
        when :each, :not
          [operation, *call(match[2])]
        else
          [operation, call(match[2])]
        end
      end

      def visit_key_op(match)
        operation = match[1].to_sym
        [operation, call(*match.values_at(2, 3))]
      end

      def visit_check_op(match)
        keys = match[1].split(",").map(&:to_sym)
        [:check, [keys, *call(match[2])]]
      end

      def visit_predicate_params(key, args)
        params = Predicates[key].parameters.map(&:last)
        params.map.with_index { |name, index| [name, args.fetch(index, Undefined)] }
      end

      def visit_predicate(match)
        name = match[1].to_sym
        args = match[2] ? match[3].split(",").flat_map { |value| call(value) } : EMPTY_ARRAY
        [:predicate, [name, visit_predicate_params(name, args)]]
      end

      def eval_string(rule)
        instance_eval(rule)
      rescue NameError
        rule.to_sym
      end
    end
  end
end
