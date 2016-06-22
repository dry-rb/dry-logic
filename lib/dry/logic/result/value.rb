module Dry
  module Logic
    class Result::Value < Result
      def to_ast
        if response.respond_to?(:to_ast)
          response.to_ast
        else
          [:result, [input, rule.to_ast]]
        end
      end

      def input
        rule.input != Predicate::Undefined ? rule.input : super
      end
    end
  end
end
