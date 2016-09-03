module Dry
  module Logic
    class Result
      attr_reader :success

      attr_reader :id

      attr_reader :serializer

      def initialize(success, id = nil, &block)
        @success = success
        @id = id
        @serializer = block
      end

      def success?
        success.equal?(true)
      end

      def failure?
        !success?
      end

      def type
        success? ? :success : :failure
      end

      def ast(input = Undefined)
        serializer.(input)
      end

      def to_ast
        if id
          [type, [id, ast]]
        else
          ast
        end
      end
    end
  end
end
