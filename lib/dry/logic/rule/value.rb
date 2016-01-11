module Dry
  module Logic
    class Rule::Value < Rule
      def call(input)
        Logic.Result(input, predicate.(input), self)
      end

      def type
        :val
      end
    end
  end
end
