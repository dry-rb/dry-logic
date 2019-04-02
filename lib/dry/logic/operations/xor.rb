require 'dry/logic/operations/binary'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Xor < Binary
        def type
          :xor
        end
        alias_method :operator, :type

        def call(input)
          pred = self[input]

          if !pred && block_given?
            yield
          else
            Result.new(pred, id) { ast(input) }
          end
        end

        def [](input)
          left[input] ^ right[input]
        end

        def ast(input = Undefined)
          [type, rules.map { |rule| rule.ast(input) }]
        end
      end
    end
  end
end
