require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class Implication < Binary
        def type
          :implication
        end

        def call(input)
          applied = left.(input)

          if applied.success?
            right.with(id: id).(input)
          else
            with(result: true)
          end
        end
      end
    end
  end
end
