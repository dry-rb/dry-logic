module Dry
  module Logic
    class Rule
      class Negation < Rule::Value
        def type
          :not
        end

        def call(*args)
          predicate.(*args).negated
        end
      end
    end
  end
end
