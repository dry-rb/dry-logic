module Dry
  module Logic
    class Rule::Value < Rule
      def type
        :val
      end

      def call(input)
        Logic.Result(apply(input), self, input)
      end

      def apply(input)
        predicate.(evaluate(input))
      end

      def evaluate(input)
        input
      end

      def to_ast(response = nil)
        predicate_ast = response.is_a?(Dry::Logic::Predicate::Result) ? response.to_ast : predicate.to_ast
        [type, predicate_ast]
      end
    end
  end
end
