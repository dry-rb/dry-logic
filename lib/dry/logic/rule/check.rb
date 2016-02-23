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
        Logic.Result(predicate.curry(*head).(tail), curry(*head), input)
      end

      def evaluate(input)
        evaluator[input].first
      end

      def type
        :check
      end

      def to_ary
        [type, [name, predicate.to_ary]]
      end
    end
  end
end
