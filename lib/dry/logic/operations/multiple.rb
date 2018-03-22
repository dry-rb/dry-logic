require 'dry/logic/operations/abstract'

module Dry
  module Logic
    module Operations
      class Multiple < Abstract
        def ast(input = Undefined)
          [type, rules.map { |rule| rule.ast(input) }]
        end

        def to_s
          "#{type}(#{rules.map(&:to_s).join(', ')})"
        end
      end
    end
  end
end
