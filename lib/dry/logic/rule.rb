require 'dry/core/constants'
require 'dry/equalizer'
require 'dry/logic/operations'
require 'dry/logic/result'
require 'dry/logic/rule/arity0'
require 'dry/logic/rule/arity1'

module Dry
  module Logic
    def self.Rule(*args, **options, &block)
      if args.any?
        Rule.build(*args, **options)
      elsif block
        Rule.build(block, **options)
      end
    end

    class Rule
      include Core::Constants
      include Dry::Equalizer(:predicate, :options)
      include Operators

      attr_reader :predicate

      attr_reader :options

      attr_reader :args

      attr_reader :arity

      RuleArity0 = Class.new(self) { include Arity0 }
      RuleArity1 = Class.new(self) { include Arity1 }

      def self.specialize(arity, args)
        case arity - args.size
        when 0 then RuleArity0
        when 1 then RuleArity1
        else self
        end
      end

      def self.build(predicate, args: EMPTY_ARRAY, arity: predicate.arity, **options)
        klass = specialize(arity, args)
        klass.new(predicate, { args: args, arity: arity, **options })
      end

      def initialize(predicate, options = EMPTY_HASH)
        @predicate = predicate
        @options = options
        @args = options[:args] || EMPTY_ARRAY
        @arity = options[:arity] || predicate.arity
        @fn = predicate
      end

      def type
        :rule
      end

      def id
        options[:id]
      end

      def call(*input)
        if self[*input]
          Result::SUCCESS
        else
          Result.new(false, id) { ast(*input) }
        end
      end

      def [](*input)
        @fn[*args, *input]
      end

      def curry(*new_args)
        all_args = args + new_args

        if all_args.size > arity
          raise ArgumentError, "wrong number of arguments (#{all_args.size} for #{arity})"
        end

        with(args: all_args)
      end

      def bind(object)
        if predicate.respond_to?(:bind)
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
