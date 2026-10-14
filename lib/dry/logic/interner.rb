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
      # `candidate` is asked first and must stay cheap: it guards #hash, which
      # is called on every value it lets through. `storable` is asked only of a
      # value that is about to become the shared one; a value equal to an
      # existing shared one is answered with that one, frozen as it is, so the
      # costly check runs once per distinct value.
      def initialize(candidate: ->(_) { true }, storable:)
        @candidate = candidate
        @storable = storable
        @table = ::ObjectSpace::WeakKeyMap.new
        @shared = ::ObjectSpace::WeakMap.new
      end

      def call(value)
        if @candidate.(value)
          @table.getkey(value) || store(value)
        else
          value
        end
      end

      # Compares by identity, so it never calls #hash on a value it was not
      # given: dry-schema's macros, for one, define a #hash of their own.
      def shared?(value) = @shared.key?(value)

      private

      def store(value)
        if @storable.(value)
          @table[value] = true
          @shared[value] = true
        end

        value
      end

      # A rule is stored only while everything in its options is deeply frozen:
      # changing an object it holds would change every rule sharing it.
      RULES = new(storable: ->(rule) { ::Ractor.shareable?(rule.options) })

      # An operation is looked up only when its rules are shared instances:
      # that keeps #hash away from anything else, and equal operations then
      # hold the very same rules.
      OPERATIONS = new(
        candidate: lambda { |operation|
          operation.rules.all? do |rule|
            case rule
            when Rule then RULES.shared?(rule)
            when Operations::Abstract then OPERATIONS.shared?(rule)
            else false
            end
          end
        },
        storable: ->(operation) { ::Ractor.shareable?(operation.options) }
      )
    end
  end
end
