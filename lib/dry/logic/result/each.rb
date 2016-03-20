module Dry
  module Logic
    class Result::Each < Result::Multi
      def to_ast
        failed_rules = failures.map { |idx, el| [:el, [idx, el.to_ast]] }
        [:result, [rule.evaluate(input), [:each, failed_rules]]]
      end

      def success?
        response.values.all?(&:success?)
      end

      def failures
        response.each_with_object({}) { |(idx, res), hash|
          hash[idx] = res if res.failure?
        }
      end
    end
  end
end
