require 'dry/logic/operations/binary'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class And < Binary
        def type
          :and
        end

        def call(input)
          left_result = left.(input)

          if left_result.success?
            right_result = right.(input)

            if right_result.success?
              Result.new(true, id)
            else
              Result.new(false, id) { right_result.ast(input) }
            end
          else
            Result.new(false, id) { [type, [left_result.to_ast, [:hint, right.ast(input)]]] }
          end
        end

        def [](input)
          left[input] && right[input]
        end
      end
    end
  end
end
