require 'dry/logic/operations/abstract'

module Dry
  module Logic
    module Operations
      class Set < Abstract
        def type
          :set
        end

        def call(input)
          applied = rules.map { |rule| rule.(input) }
          result = applied.all?(&:success?)

          new(applied, result: result)
        end

        def ast
          [type, rules.select(&:failure?).map(&:ast)]
        end
      end
    end
  end
end
