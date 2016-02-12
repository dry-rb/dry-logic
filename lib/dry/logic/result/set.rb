module Dry
  module Logic
    class Result::Set < Result::Multi
      def to_ary
        failed_rules = failures.map { |el| el.to_ary }
        [:result, [:set, failed_rules]]
      end
    end
  end
end
