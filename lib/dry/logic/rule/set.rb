module Dry
  module Logic
    class Rule::Set < Rule::Value
      alias_method :rules, :predicate

      def type
        :set
      end

      def arity
        -1
      end

      def apply(input)
        rules.map { |rule| rule.(input) }
      end

      def curry(*args)
        new(rules.map { |r| r.curry(*args) })
      end

      def at(*args)
        new(rules.values_at(*args))
      end

      def to_ast
        [type, rules.map { |rule| rule.to_ast }]
      end
    end
  end
end
