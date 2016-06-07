module Dry
  module Logic
    class Result::Value < Result
      def to_ast
        if response.respond_to?(:to_ast)
          response.to_ast
        else
          [:result, [rule.evaluate(input), rule.to_ast(input)]]
        end
      end
    end
  end
end
