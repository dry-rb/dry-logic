require 'dry/logic/operations/multiple'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Part < Multiple
        def type
          :part
        end

        def call(input)
          results = rules.map { |rule| rule.(input) }
          success = results.any?(&:success?)

          return Result::SUCCESS if success

          Result.new(success, id) do
            [type, results.map { |failure| failure.to_ast }]
          end
        end

        def [](input)
          rules.map { |rule| rule[input] }.any?
        end
      end
    end
  end
end
