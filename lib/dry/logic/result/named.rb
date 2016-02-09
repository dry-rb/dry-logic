module Dry
  module Logic
    class Result::Named < Result::Value
      def to_ary
        [:input, [rule.name, [super]]]
      end
    end
  end
end
