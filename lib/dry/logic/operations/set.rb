require 'dry/logic/operations/multiple'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Set < Multiple
        def type
          :set
        end

        def call(input)
          results = rules.map { |rule| rule.(input) }
          success = results.all?(&:success?)

          Result.new(success, id) do
            [type, results.select(&:failure?).map { |failure| failure.to_ast }]
          end
        end

        def [](input)
          rules.map { |rule| rule[input] }.all?
        end
      end
    end
  end
end
