require 'dry/logic/operations/unary'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Each < Unary
        def type
          :each
        end

        def call(input)
          if block_given?
            input.each { |e| rule.(e) { return yield } }
            Result::SUCCESS
          else
            results = input.map { |element| rule.(element) }
            success = results.all?(&:success?)

            Result.new(success, id) do
              failures = results
                .map
                .with_index { |result, idx| [:key, [idx, result.ast(input[idx])]] if result.failure? }
                .compact

              [:set, failures]
            end
          end
        end

        def [](arr)
          arr.map { |input| rule[input] }.all?
        end
      end
    end
  end
end
