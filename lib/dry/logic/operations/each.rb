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

        def to_ast
          if applied?
            [success? ? :success : :failure, predicate_ast]
          end
        end

        def predicate_ast
          [:each, failures.map { |rule, idx| [:path, [idx, rule.predicate_ast]] }]
        end

        def failures
          rules.map.with_index { |rule, idx| [rule, idx] if rule.failure? }.compact
        end
      end
    end
  end
end
