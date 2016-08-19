module Dry
  module Logic
    module Operators
      def and(other)
        Operations::Conjunction.new(self, other)
      end
      alias_method :&, :and

      def or(other)
        Operations::Disjunction.new(self, other)
      end
      alias_method :|, :or

      def xor(other)
        Operations::ExclusiveDisjunction.new(self, other)
      end
      alias_method :^, :xor

      def then(other)
        Operations::Implication.new(self, other)
      end
      alias_method :>, :then
    end
  end
end

require 'dry/logic/operations/conjunction'
require 'dry/logic/operations/disjunction'
require 'dry/logic/operations/implication'
require 'dry/logic/operations/exclusive_disjunction'
