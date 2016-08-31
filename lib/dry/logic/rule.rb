require 'dry/equalizer'
require 'dry/logic/operations'
require 'dry/logic/applicable'

module Dry
  module Logic
    def self.Rule(*args, **options, &block)
      if args.any?
        Rule.new(*args, options)
      elsif block
        Rule.new(block, options)
      end
    end

    class Rule
      include Dry::Equalizer(:predicate, :options)
      include Operators
      include Applicable

      DEFAULT_OPTIONS = { args: [].freeze, result: nil }.freeze

      attr_reader :predicate

      attr_reader :options

      attr_reader :name

      attr_reader :args

      attr_reader :arity

      def initialize(predicate, options = DEFAULT_OPTIONS)
        super
        @predicate = predicate
        @options = options
        @name = options[:name]
        @args = options[:args]
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

      def bind(object)
        self.class.new(predicate.bind(object), options)
      end

      def eval_args(object)
        with(args: args.map { |arg| arg.is_a?(UnboundMethod) ? arg.bind(object).() : arg })
      end

      def with(new_opts)
        self.class.new(predicate, options.merge(new_opts))
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
