# frozen_string_literal: true

require "dry/logic/predicates"
require_relative "local_predicates"

module Dry
  module Logic
    module Build
      class Predicate < Base
        def method_missing(method, *args, **kwargs, &block)
          super unless respond_to_missing?(method)
          super if Kernel.block_given?
          super unless kwargs.empty?

          to_predicate(method).curry(*args)
        end

        def respond_to_missing?(method, *)
          predicates.methods.include?(method)
        end

        def predicate(name, &block)
          # Remove the existing predicate defined by user
          # Without this a warning is shown similar to:
          #   warning: method redefined; discarding old {name}
          if respond_to_missing?(name)
            predicates.singleton_class.undef_method(name)
          end

          predicates[:predicate].call(name, &block)
        end

        private

        def to_predicate(name)
          (@predicate ||= {})[name] ||= Rule::Predicate.new(predicates[name])
        end

        def predicates
          LocalPredicates
        end
      end
    end
  end
end
