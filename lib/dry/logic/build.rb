# frozen_string_literal: true

require "dry/inflector"
require_relative "build/base"
require_relative "build/predicate"
require_relative "build/operation"

module Dry
  module Logic
    module Build
      def call(&block)
        Operation.call(&block)
      rescue NoMethodError
        Predicate.call(&block)
      end

      module_function :call
      alias_method :build, :call
    end
  end
end
