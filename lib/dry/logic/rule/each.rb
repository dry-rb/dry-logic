module Dry
  module Logic
    class Rule::Each < Rule::Value
      def apply(input)
        Hash[input.map.with_index { |element, index| [index, predicate.(element)] }]
      end

      def type
        :each
      end
    end
  end
end
