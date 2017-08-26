require 'dry/core/constants'
require 'dry/equalizer'
require 'dry/logic/operations'
require 'dry/logic/result'

module Dry
  module Logic
    def self.Rule(*args, **options, &block)
      if args.any?
        Rule.new(*args, Rule::DEFAULT_OPTIONS.merge(options))
      elsif block
        Rule.new(block, Rule::DEFAULT_OPTIONS.merge(options))
      end
    end

    class Rule
      include Core::Constants
      include Dry::Equalizer(:predicate, :options)
      include Operators

      DEFAULT_OPTIONS = { args: [].freeze }.freeze

      attr_reader :predicate

      attr_reader :options

      attr_reader :args

      attr_reader :arity

      def initialize(predicate, options = DEFAULT_OPTIONS)
        @predicate = predicate
        @options = options
        @args = options[:args]
        @arity = options[:arity] || predicate.arity
      end

      def type
        :rule
      end

      def id
        options[:id]
      end

      def call(*input)
        Result.new(self[*input], id) { ast(*input) }
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
        if UnboundMethod === predicate
          self.class.new(predicate.bind(object), options)
        else
          self.class.new(
            -> *args { object.instance_exec(*args, &predicate) },
            options.merge(arity: arity, parameters: parameters)
          )
        end
      end

      def eval_args(object)
        with(args: args.map { |arg| UnboundMethod === arg ? arg.bind(object).() : arg })
      end

      def with(new_opts)
        self.class.new(predicate, options.merge(new_opts))
      end

      def parameters
        options[:parameters] || predicate.parameters
      end

      def ast(input = Undefined)
        [:predicate, [id, args_with_names(input)]]
      end

      private

      def args_with_names(*input)
        parameters.map(&:last).zip(args + input)
      end
    end
  end
end
