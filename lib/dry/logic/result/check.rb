module Dry
  module Logic
    class Result::Check < Result::Named
      def to_ast
        if response.respond_to?(:to_ast) && !response.is_a?(Result) && !response.is_a?(Dry::Logic::Predicate::Result)
          response.to_ast
        else
          [:input, [rule.name, [:result, [rule.evaluate(input), [rule.type, [rule.name, response.to_ast]]]]]]
        end
      end
    end
  end
end
