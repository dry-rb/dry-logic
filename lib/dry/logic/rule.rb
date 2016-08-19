require 'dry/logic/operators'

module Dry
  module Logic
    class Rule
      include Dry::Equalizer(:predicate, :options)
      include Operators

      DEFAULT_OPTIONS = { args: [].freeze, result: nil }.freeze

      attr_reader :predicate

      attr_reader :options

      attr_reader :name

      attr_reader :args

      attr_reader :arity

      attr_reader :result

      def initialize(predicate, options = DEFAULT_OPTIONS)
        @predicate = predicate
        @options = options
        @name = options[:name]
        @args = options[:args]
        @result = options[:result]
        @arity = options[:arity] || predicate.arity
      end

      def type
        :rule
      end

      def call(*input)
        with(args: [*args, *input], result: self[*input])
      end

      def [](*input)
        arity == 0 ? predicate.() : predicate[*args, *input]
      end

      def curry(*new_args)
        all_args = args + new_args

        if all_args.size > arity
          raise ArgumentError, "wrong number of arguments (#{all_args.size} for #{arity})"
        else
          with(args: all_args)
        end
      end

      def applied?
        !result.nil?
      end

      def success?
        result.equal?(true)
      end

      def failure?
        !success?
      end

      def with(new_opts)
        self.class.new(predicate, options.merge(new_opts))
      end

      def to_ast
        if applied?
          [success? ? :success : :failure, predicate_ast]
        else
          predicate_ast
        end
      end

      private

      def parameters
        predicate.parameters
      end

      def args_with_names
        parameters.map(&:last).zip(args + Array.new(arity - args.size, Undefined))
      end
    end
  end
end
