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

      attr_reader :id, :args, :fn, :parameters, :arity

      def initialize(id, **options, &block)
        @id = id
        @fn = block
        @args = options.fetch(:args, [])
        @arity = options.fetch(:arity, block.arity)
        @parameters = options.fetch(:parameters, block.parameters)
      end

      def curry(*args)
        self.class.new(id, arity: arity, parameters: parameters, args: args, &fn.curry.(*args))
      end

      def call(*args)
        fn.(*args)
      end

      def to_ast(input = nil)
        [:predicate, [id, args_with_names(input)]]
      end
      alias_method :to_a, :to_ast

      private
      def args_with_names(*input)
        all_args = input.empty? ? args : args + input
        parameters.map(&:last).zip(all_args)
      end
    end
  end
end
