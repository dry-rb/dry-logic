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

      def args
        @args ||= predicate.args
      end

      def input
        predicate.args.last
      end

      def call(input)
        if nulary?
          Logic.Result(predicate.(), self, input)
        else
          evaled = evaluate(input)
          result = apply(evaled)
          rule = result == true ? self : curry(evaled)
          Logic.Result(result, rule, input)
        end
      end

      def apply(input)
        predicate.(input)
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
