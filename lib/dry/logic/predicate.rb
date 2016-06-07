module Dry
  module Logic
    def self.Predicate(block)
      case block
      when Method then Predicate.new(block.name, &block)
      else raise ArgumentError, 'predicate needs an :id'
      end
    end

    class Predicate
      include Dry::Equalizer(:id, :args)

      attr_reader :id, :args, :fn

      def initialize(id, *args, &block)
        @id = id
        @fn = block
        @args = args
      end

      #as long as we keep track of the args, we don't actually need to curry the proc...
      #if we never curry the proc then fn.arity & fn.parameters stay intact
      def curry(*args)
        self.class.new(id, *(@args + args), &fn)
      end

      def call(*args)
        all_args = @args+args
        if all_args.size == arity
          fn.(*all_args)
        else
          raise ArgumentError, "wrong number of arguments (#{all_args.size} for #{arity})"
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
        parameters.map(&:last).zip(args)
      end
    end
  end
end
