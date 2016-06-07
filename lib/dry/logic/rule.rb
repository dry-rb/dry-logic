module Dry
  module Logic
    class Rule
      include Dry::Equalizer(:predicate, :options)

      attr_reader :predicate

      attr_reader :options

      def initialize(predicate, options = {})
        @predicate = predicate
        @options = options
      end

      def predicate_id
        predicate.id
      end

      def type
        raise NotImplementedError
      end

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
        self.class.new(predicate, options)
      end

      #in some cases, predicate can actually be an array of predicates
      def curry(*args)
        curried_predicate = predicate.is_a?(Array) ? predicate.map{|p| p.curry(*args)} : predicate.curry(*args)
        self.class.new(curried_predicate, options)
      end

      def each?
        predicate.is_a?(Rule::Each)
      end
    end
  end
end

require 'dry/logic/rule/value'
require 'dry/logic/rule/key'
require 'dry/logic/rule/attr'
require 'dry/logic/rule/each'
require 'dry/logic/rule/set'
require 'dry/logic/rule/composite'
require 'dry/logic/rule/negation'
require 'dry/logic/rule/check'

require 'dry/logic/result'
