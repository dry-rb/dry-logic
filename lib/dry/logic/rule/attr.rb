module Dry
  module Logic
    class Rule::Attr < Rule::Key
      def self.evaluator(name)
        Evaluator::Attr.new(name)
      end

      def type
        :attr
      end
    end
  end
end
