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

      def to_ast(input = nil)
        [type, predicate.to_ast(input)]
      end
    end
  end
end
