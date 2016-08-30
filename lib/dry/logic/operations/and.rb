require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class And < Binary
        def type
          :and
        end

        def call(input)
          applied = left.(input)

          if applied.success?
            right.(input)
          else
            applied
          end
        end
      end
    end
  end
end
