module Dry
  module Logic
    class Rule::Set < Rule::Value
      alias_method :rules, :predicate

      def type
        :set
      end

      def apply(input)
        rules.map { |rule| rule.(input) }
      end

      def curry(*args)
        self.class.new(rules.map{|r| r.curry(*args)}, options)
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
