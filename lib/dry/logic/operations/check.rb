require 'dry/logic/operations/abstract'
require 'dry/logic/evaluator'

module Dry
  module Logic
    module Operations
      class Check < Abstract
        attr_reader :evaluator

        attr_reader :rule

        def self.new(rule, **options)
          if options[:evaluator]
            super(rule, options)
          else
            keys = options.fetch(:keys)
            evaluator = Evaluator::Set.new(keys)

            super(rule, options.merge(evaluator: evaluator))
          end
        end

        def initialize(rule, **options)
          @options = options
          @evaluator = options[:evaluator]
          @rules = [rule]
          @rule = rule
        end

        def type
          :check
        end

        def call(input)
          args = evaluator[input].reverse
          *head, tail = args

          curried = rule.curry(*head)
          applied = curried.(tail)

          new([applied], result: applied.success?)
        end

        def ast
          [type, [id, options[:keys], rule.ast]]
        end
      end
    end
  end
end
