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
        @args = options[:args] || EMPTY_ARRAY
        @arity = options[:arity] || predicate.arity
        args = @args
        arity = @arity

        case arity - args.size
        when 0
          singleton_class.class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def call
              if @fn[]
                Result::SUCCESS
              else
                Result.new(false, id) { ast }
              end
            end

            def []
              @fn.()
            end
          RUBY

          case @args.size
          when 0
            @fn = predicate
          when 1
            arg = @args[0]
            @fn = -> { @predicate[arg] }
          else
            @fn = -> { @predicate[*@args] }
          end
        when 1
          singleton_class.class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def call(input)
              if @fn[input]
                Result::SUCCESS
              else
                Result.new(false, id) { ast(input) }
              end
            end

            def [](input)
              @fn[input]
            end
          RUBY

          case args.size
          when 0
            @fn = predicate
          when 1
            arg = @args[0]
            @fn = -> input { @predicate[arg, input] }
          else
            @fn = -> input { @predicate[*@args, input] }
          end
        else
          @fn = predicate
        end
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
