module Dry
  module Logic
    def self.Result(response, rule, input)
      Result[rule].new(response, rule, input)
    end

    class Result
      include Dry::Equalizer(:success?, :input, :rule)

      attr_reader :input, :rule, :response, :success

      def self.[](type)
        case type
        when Rule::Each then Result::Each
        when Rule::Set then Result::Set
        when Rule::Check then Result::Check
        when Rule::Key, Rule::Attr then Result::Named
        else Result::Value
        end
      end

      def initialize(response, rule, input)
        @response = response
        @success = response.respond_to?(:success?) ? response.success? : response
        @rule = rule
        @input = input
      end

      def [](name)
        response[name] if response.respond_to?(:[])
      end

      def name
        nil
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
require 'dry/logic/result/named'
require 'dry/logic/result/multi'
require 'dry/logic/result/each'
require 'dry/logic/result/set'
require 'dry/logic/result/check'
