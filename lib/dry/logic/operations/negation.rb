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
          Result.new(!rule[input], id) { ast(input) }
        end
      end
    end
  end
end
