module Dry
  module Logic
    class Rule::Check < Rule
      alias_method :result, :predicate

      def call(*args)
        Logic.Result(nil, result.(*args), self)
      end

      def input
        result.input
      end

      def type
        :check
      end
    end
  end
end
