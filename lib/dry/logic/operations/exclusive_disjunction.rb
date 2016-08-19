require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class ExclusiveDisjunction < Binary
        def type
          :xor
        end

        def call(input)
          with(result: left[input] ^ right[input])
        end
      end
    end
  end
end
