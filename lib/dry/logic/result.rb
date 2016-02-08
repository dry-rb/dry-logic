module Dry
  module Logic
    def self.Result(input, value, rule)
      case value
      when Result
        value.for(input, rule)
      when Array
        Result::Set.new(input, value, rule)
      else
        Result::Value.new(input, value, rule)
      end
    end

    class Result
      include Dry::Equalizer(:success?, :input, :rule)

      attr_reader :input, :value, :rule, :name

      def initialize(input, value, rule, name = nil)
        @input = input
        @value = value
        @rule = rule
        @name = name || rule.respond_to?(:name) ? rule.name : nil
      end

      def for(input, rule)
        self.class.new(input, value, rule)
      end

      def negated
        self.class.new(input, !value, rule)
      end

      def then(other)
        if success?
          other.(input)
        else
          Logic.Result(input, true, rule)
        end
      end

      def and(other)
        if success?
          other.(input)
        else
          self
        end
      end

      def or(other)
        if success?
          self
        else
          other.(input)
        end
      end

      def xor(other)
        other_result = other.(input)
        value = success? ^ other_result.success?

        Logic.Result(other_result.input, value, rule)
      end

      def success?
        @value
      end

      def failure?
        ! success?
      end
    end
  end
end

require 'dry/logic/result/value'
require 'dry/logic/result/set'
