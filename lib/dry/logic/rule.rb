module Dry
  module Logic
    class Rule
      include Dry::Equalizer(:name, :evaluator, :predicate)

      attr_reader :name, :evaluator, :predicate

      DEFAULT_EVALUATOR = -> input { input }

      class Negation < Rule
        include Dry::Equalizer(:rule)

        attr_reader :rule

        def initialize(rule)
          @rule = rule
        end

        def call(*args)
          rule.(*args).negated
        end

        def to_ary
          [:not, rule.to_ary]
        end
      end

      def initialize(name, predicate, evaluator = DEFAULT_EVALUATOR)
        @name = name
        @evaluator = evaluator
        @predicate = predicate
      end

      def predicate_id
        predicate.id
      end

      def type
        :rule
      end

      def call(input)
        Logic.Result(input, predicate.(evaluator[input]), self)
      end

      def to_ary
        [type, [name, predicate.to_ary]]
      end
      alias_method :to_a, :to_ary

      def and(other)
        Conjunction.new(self, other)
      end
      alias_method :&, :and

      def or(other)
        Disjunction.new(self, other)
      end
      alias_method :|, :or

      def xor(other)
        ExclusiveDisjunction.new(self, other)
      end
      alias_method :^, :xor

      def then(other)
        Implication.new(self, other)
      end
      alias_method :>, :then

      def negation
        Negation.new(self)
      end

      def new(predicate)
        self.class.new(name, predicate)
      end

      def curry(*args)
        self.class.new(name, predicate.curry(*args))
      end
    end
  end
end

require 'dry/logic/evaluator'

require 'dry/logic/rule/value'
require 'dry/logic/rule/key'
require 'dry/logic/rule/attr'
require 'dry/logic/rule/each'
require 'dry/logic/rule/set'
require 'dry/logic/rule/composite'
require 'dry/logic/rule/check'

require 'dry/logic/result'
