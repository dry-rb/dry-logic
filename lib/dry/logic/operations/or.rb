require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class Or < Binary
        def type
          :or
        end

        def call(input)
          applied = left.(input)

          if applied.success?
            applied
          else
            right.with(id: id).(input)
          end
        end
      end
    end
  end
end
