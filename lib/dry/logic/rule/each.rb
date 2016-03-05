module Dry
  module Logic
    class Rule::Each < Rule::Value
      def apply(input)
        input.map { |element| predicate.(element) }
      end

      def type
        :each
      end
    end
  end
end
