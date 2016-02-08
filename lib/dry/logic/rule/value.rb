module Dry
  module Logic
    class Rule::Value < Rule
      def type
        :val
      end

      def call(input)
        Logic.Result(input, predicate.(evaluate(input)), self)
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
