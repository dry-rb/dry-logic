module Dry
  module Logic
    class Result::Named < Result::Value
      def name
        rule.name
      end

      def to_ast
        if response.respond_to?(:to_ast) && !response.is_a?(Result) && !response.is_a?(Dry::Logic::Predicate::Result)
          response.to_ast
        else
          [:input, [rule.name, super]]
        end
      end
    end
  end
end
