module Dry
  module Logic
    class Result::Value < Result
      def to_ary
        if response.is_a?(Result)
          response.to_ary
        else
          [:result, [rule.evaluate(input), [rule.to_ary]]]
        end
      end
    end
  end
end
