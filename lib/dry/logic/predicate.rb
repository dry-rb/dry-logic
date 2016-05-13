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

      attr_reader :id, :args, :fn, :arg_names

      def initialize(id, arg_names=nil, *args, &block)
        @id = id
        @fn = block
        @arg_names = arg_names ? arg_names : fn.parameters.map(&:last)
        @args = args
      end

      #args will be an array of values, could be some, all or none.
      def call(*args)
        all_args = @args+args
        if all_args.size == @arg_names.size
          Predicate::Result.new(id, fn.(*args), args_to_hash(all_args))
        else
          raise ArgumentError.new("wrong number of arguments (#{all_args.size} for #{@arg_names.size})")
        end
      end

      #args will be an array of values, could be some, all or none.
      def curry(*args)
        self.class.new(id, @arg_names, *args, &fn.curry.(*args))
      end

      #this will never include call args
      def to_ast
        [:predicate, [id, args_to_hash(@args).to_a]]
      end

      alias_method :to_a, :to_ast

      def args_to_hash(args)
        Hash[arg_names.zip(args)]
      end

      class Result
        attr_reader :id, :result, :args

        def initialize(id, result, args_hash = {})
          @id = id
          @result = result
          @args = args_hash
        end

        #tranform the result and return self
        def negated
          self.class.new(id, !result, args)
        end

        def success?
          result
        end

        def failure?
          !result
        end

        def to_ast
          [:predicate, [id, args.to_a]]
        end
      end
    end
  end
end
