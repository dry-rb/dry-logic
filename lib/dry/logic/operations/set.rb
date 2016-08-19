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

          self.class.new(applied, result: result)
        end

        def predicate_ast
          [:set, rules.select(&:failure?).map(&:predicate_ast)]
        end
      end
    end
  end
end
