require 'dry/logic/evaluator'

module Dry
  module Logic
    class Rule::Key < Rule::Value
      attr_reader :name, :evaluator

      def self.new(predicate, options)
        name = options.fetch(:name)
        super(predicate, evaluator: evaluator(options), name: name)
      end

      def self.evaluator(options)
        Evaluator::Key.new(options.fetch(:name))
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

      def to_ast(response = nil)
        predicate_ast = response.is_a?(Dry::Logic::Predicate::Result) ? response.to_ast : predicate.to_ast
        [type, [name, predicate_ast]]
      end
    end
  end
end
