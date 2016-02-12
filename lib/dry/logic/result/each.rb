module Dry
  module Logic
    class Result::Each < Result::Multi
      def to_ary
        failed_rules = failures.map { |el| [:el, [success.index(el), el.to_ary]] }
        [:result, [:each, [rule.evaluate(input), failed_rules]]]
      end
    end
  end
end
