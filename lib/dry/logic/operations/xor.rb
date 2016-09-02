require 'dry/logic/operations/binary'

module Dry
  module Logic
    module Operations
      class Xor < Binary
        def type
          :xor
        end

        def call(input)
          left_applied = left.(input)
          right_applied = right.(input)

          new([left_applied, right_applied], result: left.(input).success? ^ right.(input).success?)
        end

        def ast
          [type, rules.map { |rule| rule.to_ast }]
        end
      end
    end
  end
end
