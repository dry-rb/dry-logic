module Dry
  module Logic
    class Rule::Value < Rule
      def type
        :val
      end

      def call(input)
        Logic.Result(apply(input), curry(evaluate(input)), input)
      end

      def apply(input)
        predicate.(evaluate(input))
      end

      def evaluate(input)
        input
      end

      def to_ast
        [type, predicate.to_ast]
      end
    end
  end
end
