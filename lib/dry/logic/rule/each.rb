module Dry
  module Logic
    class Rule::Each < Rule
      include Dry::Equalizer(:rule)

      attr_reader :rule
      alias_method :predicate, :rule

      def initialize(rule)
        @rule = rule
      end

      def call(input)
        Logic.Result(input, input.map { |element| rule.(element) }, self)
      end

      def type
        :each
      end

      def to_ary
        [type, rule.to_ary]
      end
    end
  end
end
