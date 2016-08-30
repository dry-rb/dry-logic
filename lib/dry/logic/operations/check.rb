require 'dry/logic/operations/abstract'
require 'dry/logic/evaluator'

module Dry
  module Logic
    module Operations
      class Check < Abstract
        attr_reader :evaluator

        attr_reader :name

        attr_reader :predicate

        def self.new(*rules, **options)
          keys = options.fetch(:keys)
          evaluator = Evaluator::Set.new(keys)

          super(*rules, options.merge(evaluator: evaluator))
        end

        def initialize(*rules, **options)
          super
          @evaluator = options[:evaluator]
          @name = options[:name]
          @predicate = rules.first
        end

        def type
          :check
        end

        def call(input)
          args = evaluator[input].reverse
          *head, tail = args

          curried = predicate.curry(*head)
          applied = curried.(tail)

          new(applied, result: applied.success?)
        end

        def ast
          [name, predicate.ast]
        end
      end
    end
  end
end
