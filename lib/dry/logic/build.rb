# frozen_string_literal: true

require "dry/inflector"
require_relative "build/base"
require_relative "build/predicate"
require_relative "build/operation"

module Dry
  module Logic
    module Build
      def call(&block)
        begin
          Operation.call(&block)
        rescue NameError
          Predicate.call(&block)
        end
      rescue NameError => e
        raise NameError, "#{e.message} or #{Module.nesting.first}::Operation"
      end

      module_function :call
      alias_method :build, :call
    end
  end
end
