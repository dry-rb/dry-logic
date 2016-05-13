module Dry
  module Logic
    class Result::Value < Result
      def to_ast
        if response.respond_to?(:to_ast) && !response.is_a?(Dry::Logic::Predicate::Result)
          response.to_ast
        else
          rule_ast = response.is_a?(Dry::Logic::Predicate::Result) ? rule.to_ast(response) : rule.to_ast
          [:result, [rule.evaluate(input), rule_ast]]
        end
      end
    end
  end
end
