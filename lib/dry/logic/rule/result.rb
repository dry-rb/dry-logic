module Dry
  module Logic
    class Rule::Result < Rule
      def call(input)
        result = if name.is_a?(Hash)
                   parent, _ = name.to_a.flatten
                   input[parent]
                 else
                   input[name]
                 end

        if result.success?
          Result::Wrapped.new(input, predicate.(evaluate_input(input)), self)
        else
          result
        end
      end

      def evaluate_input(result)
        if name.is_a?(Hash)
          parent, child = name.to_a.flatten
          result[parent].input[child]
        else
          result[name].input
        end
      end

      def type
        :res
      end
    end
  end
end
