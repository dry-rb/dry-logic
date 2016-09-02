require 'dry/logic/operations/abstract'

module Dry
  module Logic
    module Operations
      class Binary < Abstract
        attr_reader :left

        attr_reader :right

        def initialize(*rules, **options)
          super
          @left, @right = rules
        end

        def ast
          [type, [left.ast, right.ast]]
        end
      end
    end
  end
end
