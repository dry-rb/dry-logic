module Dry
  module Logic
    class Rule
      class Negation < Rule
        include Dry::Equalizer(:rule)

        attr_reader :rule

        def initialize(rule)
          @rule = rule
        end

        def call(*args)
          rule.(*args).negated
        end

        def to_ary
          [:not, rule.to_ary]
        end
      end
    end
  end
end
