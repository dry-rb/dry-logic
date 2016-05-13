module Dry
  module Logic
    class Result::Value < Result
      def to_ast
        if response.respond_to?(:to_ast) && !response.is_a?(Dry::Logic::Predicate::Result)
          response.to_ast
        else
          [:result, [rule.evaluate(input), [rule.type, response.to_ast]]]
        end
      end
    end
  end
end
