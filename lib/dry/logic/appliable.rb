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
        if applied?
          node_name = success? ? :success : :failure
          [node_name, id ? [id, ast] : ast]
        else
          ast
        end
      end
    end
  end
end
