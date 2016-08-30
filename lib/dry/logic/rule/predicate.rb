require 'dry/logic/constants'

module Dry
  module Logic
    class Rule::Predicate < Rule
      def self.new(predicate, options = DEFAULT_OPTIONS)
        super(predicate, options.merge(name: options.fetch(:name, predicate.name)))
      end

      def type
        :predicate
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
