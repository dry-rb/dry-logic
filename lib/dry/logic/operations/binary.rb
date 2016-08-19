require 'dry/logic/operations/abstract'

module Dry
  module Logic
    module Operations
      class Binary < Abstract
        attr_reader :left

        attr_reader :right

        def initialize(*rules)
          super
          @left, @right = rules
        end
      end
    end
  end
end
