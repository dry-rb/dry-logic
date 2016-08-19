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
          applied = predicate.(input)
          self.class.new(applied, result: !applied.success?)
        end
      end
    end
  end
end
