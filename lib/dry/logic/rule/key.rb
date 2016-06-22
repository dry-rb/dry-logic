require 'dry/logic/evaluator'

module Dry
  module Logic
    class Rule::Key < Rule::Value
      attr_reader :name, :evaluator

      def self.new(predicate, options)
        name = options.fetch(:name)
        eval = options.fetch(:evaluator, evaluator(name))
        super(predicate, evaluator: eval, name: name)
      end

      def self.evaluator(name)
        Evaluator::Key.new(name)
      end

      def initialize(predicate, options)
        super
        @name = options[:name]
        @evaluator = options[:evaluator]
      end

      def evaluate(input)
        evaluator[input]
      end

      def type
        :key
      end

      def to_ast
        [type, [name, predicate.to_ast]]
      end
    end
  end
end
