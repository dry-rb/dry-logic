module Dry
  module Logic
    class Rule
      class Negation < Rule::Value
        def type
          :not
        end

        def call(input)
          predicate.(input).negated
        end
      end
    end
  end
end
