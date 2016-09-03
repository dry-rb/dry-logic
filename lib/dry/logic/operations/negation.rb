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
          Result.new(!predicate[input], id) { ast(input) }
        end

        def ast(input = Undefined)
          [type, predicate.ast(input)]
        end
      end
    end
  end
end
