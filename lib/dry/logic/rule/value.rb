module Dry
  module Logic
    class Rule::Value < Rule
      def type
        :val
      end

      def nulary?
        arity == 0
      end

      def arity
        @arity ||= predicate.arity
      end

      def call(input)
        if nulary?
          Logic.Result(predicate.(), self, input)
        else
          Logic.Result(apply(input), curry(evaluate(input)), input)
        end
      end

      def apply(input)
        predicate.(evaluate(input))
      end

      def evaluate(input)
        input
      end

      def to_ast
        [type, predicate.to_ast]
      end
    end
  end
end
