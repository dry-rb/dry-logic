module Dry
  module Logic
    def self.Result(input, value, rule)
      case value
      when Array
        Result::Set.new(input, value, rule)
      else
        Result::Value.new(input, value, rule)
      end
    end

    class Result
      include Dry::Equalizer(:success?, :input, :rule)

      attr_reader :input, :value, :rule, :name

      class Result::Set < Result
        def success?
          value.all?(&:success?)
        end

        def to_ary
          indices = value.map { |v| v.failure? ? value.index(v) : nil }.compact
          values = value.values_at(*indices)

          failures =
            if each?
              values.map { |el| [:el, [value.index(el), el.to_ary]] }
            else
              values.map { |el| el.to_ary }
            end

          [:input, [name, input, failures]]
        end

        def [](name)
          input[name]
        end

        def each?
          rule.type == :each
        end
      end

      class Result::Value < Result
        def to_ary
          [:input, [name, input, [rule.to_ary]]]
        end
        alias_method :to_a, :to_ary
      end

      class Result::LazyValue < Result
        def to_ary
          [:input, [name, input, [rule.to_ary]]]
        end
        alias_method :to_a, :to_ary

        def input
          success? ? rule.evaluate_input(@input) : @input
        end
      end

      def initialize(input, value, rule)
        @input = input
        @value = value
        @rule = rule
        @name = rule.name
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
