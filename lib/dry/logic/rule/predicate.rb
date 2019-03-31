require 'dry/logic/rule'

module Dry
  module Logic
    class Rule::Predicate < Rule
      PredicateArity0 = Class.new(self) { include Arity0 }
      PredicateArity1 = Class.new(self) { include Arity1 }

      def self.specialize(arity, args)
        case arity - args.size
        when 0 then PredicateArity0
        when 1 then PredicateArity1
        else self
        end
      end

      def type
        :predicate
      end

      def name
        predicate.name
      end

      def to_s
        if args.size > 0
          "#{name}(#{args.map(&:inspect).join(', ')})"
        else
          "#{name}"
        end
      end

      def ast(input = Undefined)
        [type, [name, args_with_names(input)]]
      end
      alias_method :to_ast, :ast
    end
  end
end
