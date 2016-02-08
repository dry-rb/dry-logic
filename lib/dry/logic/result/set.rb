module Dry
  module Logic
    class Result::Set < Result
      def success?
        success.all?(&:success?)
      end

      def to_ary
        indices = success.map { |v| v.failure? ? success.index(v) : nil }.compact
        values = success.values_at(*indices)

        failures =
          if rule.each?
            values.map { |el| [:el, [success.index(el), el.to_ary]] }
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
