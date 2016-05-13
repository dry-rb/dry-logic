require 'dry/logic/evaluator'

module Dry
  module Logic
    class Rule::Check < Rule::Value
      attr_reader :name, :evaluator, :predicate

      def self.new(predicate, options)
        keys = options.fetch(:keys)
        evaluator = Evaluator::Set.new(keys)

        super(predicate, options.merge(evaluator: evaluator))
      end

      def initialize(predicate, options)
        super
        @name = options.fetch(:name)
        @evaluator = options[:evaluator]
        @predicate = predicate
      end

      def call(input)
        args = evaluator[input]
        *head, tail = args
        if head.size > 0
          rule = curry(*head)
          predicate_result = predicate.curry(*head).(tail)
        else
          rule = self
          predicate_result = predicate.(tail)
        end

        Logic.Result(predicate_result, rule, input)
      end

      def evaluate(input)
        evaluator[input].first
      end

      def type
        :check
      end

      def to_ast(response = nil)
        rule_ast = response.is_a?(Dry::Logic::Predicate::Result) ? response.to_ast : predicate.to_ast
        [type, [name, rule_ast]]
      end
    end
  end
end
