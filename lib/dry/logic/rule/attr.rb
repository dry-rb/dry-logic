module Dry
  module Logic
    class Rule::Attr < Rule::Key
      def self.evaluator(options)
        Evaluator::Attr.new(options.fetch(:name))
      end

      def type
        :attr
      end
    end
  end
end
