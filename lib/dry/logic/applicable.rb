module Dry
  module Logic
    module Applicable
      attr_reader :result

      def initialize(*, **options)
        @result = options[:result]
      end

      def applied?
        !result.nil?
      end

      def success?
        result.equal?(true)
      end

      def failure?
        !success?
      end

      def to_ast
        applied? ? [success? ? :success : :failure, ast] : ast
      end
    end
  end
end
