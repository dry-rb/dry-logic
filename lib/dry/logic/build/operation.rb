# frozen_string_literal: true

module Dry
  module Logic
    module Build
      class Operation < Base
        def method_missing(method, *args, &block)
          super unless respond_to_missing?(method)
          super unless Kernel.block_given?

          Tree.new([method, [*args, to_predicate(&block)]])
        end

        def respond_to_missing?(method, *)
          defined?(to_class_name(method))
        end

        private

        def to_operation(name)
          Kernel.eval(to_class_name(name))
        end

        def to_class_name(name)
          ["Operations", name.capitalize].join("::")
        end

        def to_predicate(&block)
          Build.construct(&block).ast
        end

        memoize :to_class_name
      end
    end
  end
end
