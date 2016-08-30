module Dry
  module Logic
    module Operators
      def and(other)
        Operations::And.new(self, other)
      end
      alias_method :&, :and

      def or(other)
        Operations::Or.new(self, other)
      end
      alias_method :|, :or

      def xor(other)
        Operations::Xor.new(self, other)
      end
      alias_method :^, :xor

      def then(other)
        Operations::Implication.new(self, other)
      end
      alias_method :>, :then
    end
  end
end

require 'dry/logic/operations/and'
require 'dry/logic/operations/or'
require 'dry/logic/operations/xor'
require 'dry/logic/operations/implication'
