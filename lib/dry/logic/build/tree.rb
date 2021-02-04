module Dry
  module Logic
    module Build
      class Tree < BasicObject
        MAP = { :> => :implication, :| => :or, :& => :and, :^ => :xor }.freeze

        attr_reader :ast

        def initialize(ast)
          @ast = ast
        end

        def method_missing(meth, *args, &blk)
          Tree.new([MAP[meth], [ast, *args.map(&:ast)]])
        end
      end
    end
  end
end
