module Dry
  module Logic
    class Result::Value < Result
      def to_ary
        if name
          [:input, [name, rule.evaluate(input), [rule.to_ary]]]
        else
          [:input, [rule.evaluate(input), [rule.to_ary]]]
        end
      end
    end
  end
end
