module Dry
  module Logic
    class Rule::Result < Rule
      def call(input)
        result = input[name]
        result_input = result.input

        if result.success?
          Result::Wrapped.new(input, predicate.(result_input), self)
        else
          result
        end
      end

      def type
        :res
      end
    end
  end
end
