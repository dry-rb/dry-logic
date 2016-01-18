module Dry
  module Logic
    class Rule::Result < Rule
      def call(input)
        result = input[name]
        return result unless result.success?
        result_input = result.input
        Logic.Result(result_input, predicate.(result_input), self)
      end

      def type
        :res
      end
    end
  end
end
