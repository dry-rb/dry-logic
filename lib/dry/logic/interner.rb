# frozen_string_literal: true

module Dry
  module Logic
    # Hands out one instance for each group of equal values, so a value built
    # over and over (dry-schema builds the same `filled?` or `max_size?(255)`
    # rule for every key that uses it) is kept once. The table holds values
    # weakly: one built at runtime and then dropped is collected as usual.
    #
    # @api private
    class Interner
      def initialize(&shareable)
        @shareable = shareable
        @table = ::ObjectSpace::WeakKeyMap.new
      end

      def call(value)
        if @shareable.(value)
          @table.getkey(value) || value.tap { @table[value] = true }
        else
          value
        end
      end

      # A rule is shared only while everything in its options is frozen:
      # changing an object it holds would change every rule sharing it.
      RULES = new { |rule|
        rule.options.all? do |key, value|
          if key.equal?(:args)
            value.frozen? && value.all?(&:frozen?)
          else
            value.frozen?
          end
        end
      }
    end
  end
end
