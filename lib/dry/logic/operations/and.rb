require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class And < Binary
        def type
          :and
        end

        def call(input)
          applied = left.with(id: id).(input)

          if applied.success?
            right.with(id: id).(input)
          else
            applied
          end
        end
      end
    end
  end
end
