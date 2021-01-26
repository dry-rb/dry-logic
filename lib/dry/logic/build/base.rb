# frozen_string_literal: true

module Dry
  module Logic
    module Build
      class Base < BasicObject
        include ::Dry::Logic

        def self.call(&block)
          new.instance_eval(&block)
        end

        def self.const_missing(name)
          ::Object.const_get(name)
        end

        def predicate(*args, &block)
          Predicates[:predicate].call(*args, &block)
        end

        if respond_to?(:ruby2_keywords, true)
          ruby2_keywords(:predicate)
        end
      end
    end
  end
end
