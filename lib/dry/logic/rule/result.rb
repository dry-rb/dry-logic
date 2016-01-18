module Dry
  module Logic
    class Rule::Result < Rule
      def call(result)
        return result unless result.success?
        input = result.input
        Logic.Result(input, predicate.(input), self)
      end

      def type
        :res
      end
    end
  end
end
