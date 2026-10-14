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
        @shared = ::ObjectSpace::WeakMap.new
      end

      def call(value)
        if shareable?(value)
          @table.getkey(value) || value.tap do
            @table[value] = true
            @shared[value] = true
          end
        else
          value
        end
      end

      def shareable?(value) = @shareable.(value)

      # Compares by identity, so it never calls #hash on a value it was not
      # given: dry-schema's macros, for one, define a #hash of their own.
      def shared?(value) = @shared.key?(value)

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

      # An operation is shared only when its rules are: an equal operation
      # holding an unshared rule would hand that rule to every user.
      OPERATIONS = new { |operation|
        operation.options.each_value.all?(&:frozen?) &&
          operation.rules.all? do |rule|
            case rule
            when Rule then RULES.shared?(rule)
            when Operations::Abstract then OPERATIONS.shared?(rule)
            else false
            end
          end
      }
    end
  end
end
