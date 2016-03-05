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

      def to_ary
        [type, predicate.to_ary]
      end
    end
  end
end
