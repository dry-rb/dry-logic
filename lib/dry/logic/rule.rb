module Dry
  module Logic
    class Rule
      include Dry::Equalizer(:predicate, :options)

      attr_reader :predicate

      attr_reader :options

      def self.method_added(meth)
        super
        if meth == :call
          alias_method :[], :call
        end
      end

      def initialize(predicate, options = {})
        @predicate = predicate
        @options = options
      end

      def inspect
        "#<Dry::Logic::Rule[#{predicate.sig}]>"
      end
      alias_method :to_s, :inspect

      def sig
        predicate.sig
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

      def curry(*args)
        if arity > 0
          new(predicate.curry(*args))
        else
          self
        end
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
