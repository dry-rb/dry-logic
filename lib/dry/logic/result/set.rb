module Dry
  module Logic
    class Result::Set < Result
      def success?
        value.all?(&:success?)
      end

      def to_ary
        indices = value.map { |v| v.failure? ? value.index(v) : nil }.compact
        values = value.values_at(*indices)

        failures =
          if rule.each?
            values.map { |el| [:el, [value.index(el), el.to_ary]] }
          else
            values.map { |el| el.to_ary }
          end

        if name
          [:input, [name, input, failures]]
        else
          [:input, [input, failures]]
        end
      end

      def each?
        rule.type == :each
      end
    end
  end
end
