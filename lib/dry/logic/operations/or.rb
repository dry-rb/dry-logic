require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class Or < Binary
        def type
          :or
        end

        def call(input)
          left_result = left.(input)

          if left_result.success?
            Result::SUCCESS
          else
            right_result = right.(input)
            Result.new(right_result.success?, id) { right_result.ast(input) }
          end
        end

        def [](input)
          left[input] || right[input]
        end
      end
    end
  end
end
