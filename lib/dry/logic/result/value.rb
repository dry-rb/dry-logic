module Dry
  module Logic
    class Result::Value < Result
      def to_ary
        [:result, [rule.evaluate(input), [rule.to_ary]]]
      end
    end
  end
end
