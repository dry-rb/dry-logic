require 'dry/logic/operations/abstract'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Set < Abstract
        def type
          :set
        end

        def call(input)
          if block_given?
            rules.each { |r| r.(input) { return yield } }
            Result::SUCCESS
          else
            results = rules.map { |rule| rule.(input) }
            success = results.all?(&:success?)

            Result.new(success, id) do
              [type, results.select(&:failure?).map { |failure| failure.to_ast }]
            end
          end
        end

        def [](input)
          rules.map { |rule| rule[input] }.all?
        end

        def ast(input = Undefined)
          [type, rules.map { |rule| rule.ast(input) }]
        end

        def to_s
          "#{type}(#{rules.map(&:to_s).join(', ')})"
        end
      end
    end
  end
end
