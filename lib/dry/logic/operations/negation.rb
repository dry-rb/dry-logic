require 'dry/logic/operations/negation'

module Dry
  module Logic
    module Operations
      class Negation < Abstract
        attr_reader :predicate

        def initialize(*rules, **options)
          super
          @predicate = rules.first
        end

        def type
          :not
        end

        def call(input)
          applied = predicate.with(id: id).(input)
          new(applied, result: !applied.success?)
        end

        def ast
          [type, predicate.ast]
        end
      end
    end
  end
end
