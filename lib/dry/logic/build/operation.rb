# frozen_string_literal: true

module Dry
  module Logic
    module Build
      class Operation < Base
        INFLECTOR = Dry::Inflector.new.freeze

        def method_missing(method, *args, **kwargs, &block)
          super unless respond_to_missing?(method)
          super unless Kernel.block_given?

          to_operation(method).new(*to_predicate(&block), *args, **kwargs)
        end

        def respond_to_missing?(method, *)
          !to_operation(method).nil?
        rescue NameError
          false
        end

        private

        def to_operation(name)
          Kernel.eval(INFLECTOR.camelize("operations/#{name}"))
        end

        def to_predicate(&block)
          Build.call(&block)
        end
      end
    end
  end
end
