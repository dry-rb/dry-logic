require 'dry/logic/rule'

module Dry
  module Logic
    class RuleCompiler
      attr_reader :predicates

      def initialize(predicates)
        @predicates = predicates
      end

      def call(ast)
        ast.to_ary.map { |node| visit(node) }
      end

      def visit(node)
        name, nodes = node
        send(:"visit_#{name}", nodes)
      end

      def visit_check(node)
        name, predicate, keys = node
        Rule::Check.new(name, visit(predicate), keys)
      end

      def visit_res(node)
        name, predicate = node
        Rule::Result.new(name, visit(predicate))
      end

      def visit_args(nodes)
        nodes.map { |node| visit(node) }
      end

      def visit_res_arg(name)
        predicates[name].input
      end

      def visit_arg(value)
        value
      end

      def visit_not(node)
        visit(node).negation
      end

      def visit_key(node)
        name, predicate = node
        Rule::Key.new(name, visit(predicate))
      end

      def visit_attr(node)
        name, predicate = node
        Rule::Attr.new(name, visit(predicate))
      end

      def visit_val(node)
        name, predicate = node
        Rule::Value.new(name, visit(predicate))
      end

      def visit_set(node)
        name, rules = node
        Rule::Set.new(name, call(rules))
      end

      def visit_each(node)
        name, rule = node
        Rule::Each.new(name, visit(rule))
      end

      def visit_predicate(node)
        name, args = node

        if args[0] == :args
          predicates[name].curry(*visit(args))
        else
          predicates[name].curry(*args)
        end
      end

      def visit_and(node)
        left, right = node
        visit(left) & visit(right)
      end

      def visit_or(node)
        left, right = node
        visit(left) | visit(right)
      end

      def visit_xor(node)
        left, right = node
        visit(left) ^ visit(right)
      end

      def visit_implication(node)
        left, right = node
        visit(left) > visit(right)
      end

      def visit_group(node)
        identifier, predicate = node
        Rule::Group.new(identifier, visit(predicate))
      end
    end
  end
end
