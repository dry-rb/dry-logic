module Dry
  module Logic
    class Result::Set < Result::Multi
      def to_ast
        failed_rules = failures.map { |el| el.to_ast }
        [:result, [input, [:set, failed_rules]]]
      end
    end
  end
end
