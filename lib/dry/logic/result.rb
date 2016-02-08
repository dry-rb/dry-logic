module Dry
  module Logic
    def self.Result(input, success, rule)
      case success
      when Result
        success.for(input, rule)
      when Array
        Result::Set.new(input, success, rule)
      else
        Result::Value.new(input, success, rule)
      end
    end

    class Result
      include Dry::Equalizer(:success?, :input, :rule)

      attr_reader :input, :success, :rule, :name

      def initialize(input, success, rule, name = nil)
        @input = input
        @success = success
        @rule = rule
        @name = name || rule.respond_to?(:name) ? rule.name : nil
      end

      def for(input, rule)
        self.class.new(input, success, rule)
      end

      def negated
        self.class.new(input, !success, rule)
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
        success = success? ^ other_result.success?

        Logic.Result(other_result.input, success, rule)
      end

      def success?
        @success
      end

      def failure?
        !success?
      end
    end
  end
end

require 'dry/logic/result/value'
require 'dry/logic/result/set'
