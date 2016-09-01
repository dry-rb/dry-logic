module Dry
  module Logic
    module Appliable
      def id
        options[:id]
      end

      def result
        options[:result]
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
