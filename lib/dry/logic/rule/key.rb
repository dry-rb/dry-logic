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

      def to_ary
        [type, [name, predicate.to_ary]]
      end
    end
  end
end
