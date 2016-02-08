module Dry
  module Logic
    class Rule::Set < Rule
      attr_reader :rules

      def initialize(rules)
        @rules = rules
      end

      def call(input)
        Logic.Result(input, rules.map { |rule| rule.(input) }, self)
      end

      def type
        :set
      end

      def at(*args)
        self.class.new(name, rules.values_at(*args))
      end

      def to_ary
        [type, rules.map(&:to_ary)]
      end
      alias_method :to_a, :to_ary
    end
  end
end
