module Dry
  module Logic
    class Rule::Key < Rule
      def self.new(name, predicate)
        super(name, predicate, Evaluator::Key.new(name))
      end

      def type
        :key
      end
    end
  end
end
