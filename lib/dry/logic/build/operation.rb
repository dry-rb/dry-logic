# frozen_string_literal: true

module Dry
  module Logic
    module Build
      class Operation < Base
        def method_missing(method, *args, **kwargs, &block)
          super unless respond_to_missing?(method)
          super unless Kernel.block_given?

          to_operation(method).new(*to_predicate(&block), *args, **kwargs)
        end

        def respond_to_missing?(method, *)
          defined?(to_class_name(method))
        end

        private

        def to_operation(name)
          Kernel.eval(to_class_name(name))
        end

        def to_class_name(name)
          (@class_name ||= {})[name] ||= ["Operations", name.capitalize].join("::")
        end

        def to_predicate(&block)
          Build.call(&block)
        end
      end
    end
  end
end
