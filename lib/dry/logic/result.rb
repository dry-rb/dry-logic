module Dry
  module Logic
    def self.Result(response, rule, input)
      case response
      when Result
        response.for(rule, input)
      else
        Result[rule.type].new(response, rule, input)
      end
    end

    class Result
      include Dry::Equalizer(:success?, :input, :rule)

      attr_reader :input, :rule, :success

      def self.[](type)
        case type
        when :each then Result::Each
        when :set then Result::Set
        else Result::Value
        end
      end

      def initialize(response, rule, input)
        @success = response
        @rule = rule
        @input = input
      end

      def for(rule, input)
        self.class.new(success, rule, input)
      end

      def negated
        self.class.new(!success, rule, input)
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
require 'dry/logic/result/multi'
require 'dry/logic/result/each'
require 'dry/logic/result/set'
