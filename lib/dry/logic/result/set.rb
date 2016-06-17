module Dry
  module Logic
    class Result::Set < Result::Multi
      def to_ast
        failed_rules = failures.map(&:to_ast)
        [:result, [rule.evaluate(input), [:set, failed_rules]]]
      end
    end
  end
end
