# frozen_string_literal: true

require "dry/logic/predicates"
require_relative "local_predicates"

module Dry
  module Logic
    module Build
      class Predicate < Base
        include Dry::Core::Constants
        #
        # Defines a user defined predicate
        #
        # @name [Symbol] A predicate name
        # @block [Proc] Block containing the predicate logic
        # @example Checks input is equals to 10
        #   predicate(:ten?) do |input|
        #     input == 10
        #   end
        #
        #   is_ten = predicates[:ten?]
        #
        #   is_ten.call(10).success? # => true
        #   is_ten.call(11).success? # => false
        #
        def predicate(name, &block)
          # Remove the existing predicate defined by user
          # Without this a warning is shown similar to:
          #   warning: method redefined; discarding old {name}
          if respond_to_missing?(name)
            predicates.singleton_class.undef_method(name)
          end

          predicates[:predicate].call(name, &block)
        end

        def method_missing(method, *args, **kwargs, &block)
          super unless respond_to_missing?(method)
          super if Kernel.block_given?
          super unless kwargs.empty?

          Tree.new([:predicate, [method, [[:_, Undefined]] + args.map { |a| [:_, a] }]])
        end

        def respond_to_missing?(method, *)
          predicates.singleton_class.method_defined?(method)
        end

        private

        def to_predicate(name)
          Rule::Predicate.new(predicates[name])
        end

        def predicates
          LocalPredicates
        end

        memoize :to_predicate
      end
    end
  end
end
