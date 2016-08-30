module Dry
  module Logic
    module Operators
      def and(other)
        Operations::And.new(self, other)
      end
      alias & and

      def or(other)
        Operations::Or.new(self, other)
      end
      alias | or

      def xor(other)
        Operations::Xor.new(self, other)
      end
      alias ^ xor

      def then(other)
        Operations::Implication.new(self, other)
      end
      alias > then
    end
  end
end
