module Dry
  module Logic
    class Rule::Check < Rule
      alias_method :result, :predicate

      def call(*)
        Logic.Result(nil, result.call, self)
      end

      def type
        :check
      end
    end
  end
end
