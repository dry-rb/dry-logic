require 'dry/logic/operations/binary'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Implication < Binary
        def type
          :implication
        end

        def operator
          :then
        end

        def call(input, &block)
          if block_given?
            left.(input) { return Result::SUCCESS }
            right.(input, &block)
          else
            left_result = left.(input)

            if left_result.success?
              right_result = right.(input)

              Result.new(right_result.success?, id) { right_result.to_ast }
            else
              Result::SUCCESS
            end
          end
        end

        def [](input)
          if left[input]
            right[input]
          else
            true
          end
        end
      end
    end
  end
end
