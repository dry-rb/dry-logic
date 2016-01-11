module Dry
  module Logic
    class Rule::Key < Rule
      def self.new(name, predicate)
        super(name, predicate.curry(name))
      end

      def type
        :key
      end

      def call(input)
        Logic.Result(input[name], predicate.(input), self)
      end
    end
  end
end
