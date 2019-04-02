require 'dry/logic/operations/unary'
require 'dry/logic/result'

module Dry
  module Logic
    module Operations
      class Negation < Unary
        def type
          :not
        end

        def call(input)
          if block_given?
            rule.(input) { return Result::SUCCESS }
            yield
          else
            Result.new(rule.(input).failure?, id) { ast(input) }
          end
        end

        def [](input)
          !rule[input]
        end
      end
    end
  end
end
