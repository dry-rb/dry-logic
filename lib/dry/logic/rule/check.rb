require 'dry/logic/evaluator'

module Dry
  module Logic
    class Rule::Check < Rule::Value
      attr_reader :name, :evaluator

      def self.new(predicate, options)
        keys = options.fetch(:keys)
        evaluator = Evaluator::Set.new(keys)

        super(predicate, options.merge(evaluator: evaluator))
      end

      def initialize(predicate, options)
        super
        @name = options.fetch(:name)
        @evaluator = options[:evaluator]
      end

      def call(input)
        args = evaluator[input].reverse
        *head, tail = args
        Logic.Result(predicate.curry(*head).call(tail), curry(*args), input)
      end

      def evaluate(input)
        evaluator[input].first
      end

      def type
        :check
      end

      def to_ast
        [type, [name, predicate.to_ast]]
      end
    end
  end
end
