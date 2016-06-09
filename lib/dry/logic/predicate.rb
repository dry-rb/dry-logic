module Dry
  module Logic
    def self.Predicate(block)
      case block
      when Method then Predicate.new(block.name, &block)
      when UnboundMethod then Predicate.new(block.name, fn: block)
      else raise ArgumentError, 'predicate needs an :id'
      end
    end

    class Predicate
      Undefined = Class.new {
        def inspect
          "undefined"
        end
        alias_method :to_s, :inspect
      }.new.freeze

      include Dry::Equalizer(:id, :args)

      attr_reader :id, :args, :fn

      def initialize(id, args: [], fn: nil, &block)
        @id = id
        @args = args
        @fn = fn || block
      end

      #as long as we keep track of the args, we don't actually need to curry the proc...
      #if we never curry the proc then fn.arity & fn.parameters stay intact
      def curry(*args)
        all_args = @args + args

        if all_args.size <= arity
          self.class.new(id, args: all_args, fn: fn)
        else
          raise_arity_error(all_args.size)
        end
      end

      # @api public
      def bind(object)
        self.class.new(id, *args, &fn.bind(object))
      end

      #enables a rule to call with its params & have them ignored if the
      #predicate doesn't need them.
      #if @args.size == arity then we should ignore called args
      def call(*args)
        all_args = @args + args

        if @args.size == arity
          fn.(*@args)
        elsif all_args.size == arity
          fn.(*all_args)
        else
          raise_arity_error(all_args.size)
        end
      end

      def arity
        fn.arity
      end

      def parameters
        fn.parameters
      end

      def to_ast
        [:predicate, [id, args_with_names]]
      end
      alias_method :to_a, :to_ast

      private

      def args_with_names
        parameters.map(&:last).zip(args + Array.new(arity - args.size, Undefined))
      end

      def raise_arity_error(args_size)
        raise ArgumentError, "wrong number of arguments (#{args_size} for #{arity})"
      end
    end
  end
end
