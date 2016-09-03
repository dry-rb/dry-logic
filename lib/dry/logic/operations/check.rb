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
          *head, tail = evaluator[input].reverse
          result = rule.curry(*head).(tail)

          if result.success?
            Result::SUCCESS
          else
            Result.new(false, id) { [type, [id, options[:keys], result.to_ast]] }
          end
        end

        def [](input)
          rule[*evaluator[input].reverse]
        end

        def ast(input = Undefined)
          [type, [id, options[:keys], rule.ast(input)]]
        end
      end
    end
  end
end
