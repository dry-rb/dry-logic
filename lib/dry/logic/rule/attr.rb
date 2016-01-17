module Dry
  module Logic
    class Rule::Attr < Rule
      def self.new(name, predicate)
        super(name, predicate.curry(name))
      end

      def type
        :attr
      end

      def evaluate_input(input)
        input.public_send(name)
      end

      def call(input)
        Logic::Result::LazyValue.new(input, predicate.(input), self)
      end
    end
  end
end
