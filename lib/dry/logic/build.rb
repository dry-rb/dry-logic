# frozen_string_literal: true

require_relative "build/base"
require_relative "build/predicate"
require_relative "build/tree"
require_relative "build/operation"
require "dry/logic/rule_compiler"

module Dry
  module Logic
    module Build
      #
      # Predicate and operation builder
      #
      # @block [Proc] Block containing the logic
      # @return [Dry::Logic::Result]
      # @throws [NameError] For undefined predicates and operations
      # @example Check if value is zero, without using ==
      #   is_zero = Dry::Logic::Build.call do
      #     lt?(0) ^ gt?(0)
      #   end
      #
      #   is_zero.call(1).success? # => false
      #   is_zero.call(0).success? # => true
      #   is_zero.call(-1).success? # => false
      #
      def call(&block)
        compiler = RuleCompiler.new(LocalPredicates)
        compiler.visit(construct(&block).ast)
      end

      def construct(&block)
        Operation.call(&block)
      rescue NameError
        Predicate.call(&block)
      end

      module_function :call, :construct

      #
      # @example Check for odd numbers using {Build#build}
      #   extend Dry::Logic::Build
      #
      #   is_odd = build { odd? }
      #
      #   is_odd.call(1).success? # => true
      #   is_odd.call(2).success? # => false
      #
      alias_method :build, :call
    end
  end
end
