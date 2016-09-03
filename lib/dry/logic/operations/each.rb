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
          results = input.map { |element| predicate.(element) }
          success = results.all?(&:success?)

          Result.new(success, id) do
            failures = results
              .map
              .with_index { |result, idx| [:key, [idx, result.ast(input[idx])]] if result.failure? }
              .compact

            [:set, failures]
          end
        end

        def [](arr)
          arr.map { |input| predicate[input] }.all?
        end

        def ast(input = Undefined)
          [type, predicate.ast(input)]
        end
      end
    end
  end
end
