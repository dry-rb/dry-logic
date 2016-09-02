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
        "#{name}(#{args.map(&:inspect).join(', ')})"
      end
      alias_method :to_str, :to_s

      def ast
        [type, [name, args_with_names]]
      end
    end
  end
end
