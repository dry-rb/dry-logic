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
        Rule::Check.new(visit(predicate), name: name, keys: keys || [name])
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
        Rule::Value.new(visit(node))
      end

      def visit_set(node)
        Rule::Set.new(call(node))
      end

      def visit_each(node)
        Rule::Each.new(visit(node))
      end

      def visit_predicate(node)
        name, args = node
        predicates[name].curry(*args)
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
    end
  end
end
