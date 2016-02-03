module Dry
  module Logic
    class Rule::Check < Rule
      attr_reader :keys

      def self.new(name, predicate, keys)
        super(name, predicate, Evaluator::Set.new(keys))
      end

      def type
        :check
      end
    end
  end
end
