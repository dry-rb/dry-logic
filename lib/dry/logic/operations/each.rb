require 'dry/logic/operations/abstract'

module Dry
  module Logic
    module Operations
      class Each < Abstract
        attr_reader :predicate

        def initialize(*rules, **options)
          super
          @predicate = rules.first
        end

        def type
          :each
        end

        def call(input)
          applied = input.map { |element| predicate.(element) }
          result = applied.all?(&:success?)

          self.class.new(applied, result: result)
        end

        def ast
          if applied?
            [type, failures.map { |rule, idx| [:path, [idx, rule.ast]] }]
          else
            [type, rules.map(&:ast)]
          end
        end

        def failures
          rules.map.with_index { |rule, idx| [rule, idx] if rule.failure? }.compact
        end
      end
    end
  end
end
