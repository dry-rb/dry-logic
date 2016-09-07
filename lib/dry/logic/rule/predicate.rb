require 'dry/logic/rule'

module Dry
  module Logic
    class Rule::Predicate < Rule
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
