module Dry
  module Logic
    class Rule::Attr < Rule
      def self.new(name, predicate)
        super(name, predicate, Evaluator::Attr.new(name))
      end

      def type
        :attr
      end
    end
  end
end
