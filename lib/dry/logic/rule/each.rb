module Dry
  module Logic
    class Rule::Each < Rule::Value
      def call(input)
        Logic.Result(input, input.map { |element| predicate.(element) }, self)
      end

      def type
        :each
      end
    end
  end
end
