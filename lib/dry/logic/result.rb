module Dry
  module Logic
    def self.Result(response, rule, input)
      case response
      when Result
        response.for(rule, input)
      when Array
        Result::Set.new(response, rule, input)
      else
        Result::Value.new(response, rule, input)
      end
    end

    class Result
      include Dry::Equalizer(:success?, :input, :rule)

      attr_reader :input, :rule, :name, :success

      def initialize(response, rule, input)
        @success = response
        @rule = rule
        @name = rule.respond_to?(:name) ? rule.name : nil
        @input = input
      end

      def for(rule, input)
        self.class.new(success, rule, input)
      end

      def negated
        self.class.new(!success, rule, input)
      end

      def then(other)
        if success?
          other.(input)
        else
          Logic.Result(true, rule, input)
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
