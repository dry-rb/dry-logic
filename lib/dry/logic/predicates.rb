require 'bigdecimal'
require 'bigdecimal/util'
require 'date'

module Dry
  module Logic
    module Predicates
      module Methods
        WHITESPACE_PATTERN = /\A[[:space:]#{"\u200B\u200C\u200D\u2060\uFEFF"}]*\z/

        def [](name)
          method(name)
        end

        def type?(type, input)
          input.kind_of?(type)
        end

        def none?(input)
          input.nil?
        end

        def key?(name, input)
          input.key?(name)
        end

        def attr?(name, input)
          input.respond_to?(name)
        end

        def empty?(input)
          case input
          when String, Array, Hash then input.empty?
          when nil then true
          else
            false
          end
        end

        def filled?(input)
          !self[:empty?].(input)
        end

        def non_whitespace?(input)
          !(WHITESPACE_PATTERN =~ input)
        end

        def bool?(input)
          input.is_a?(TrueClass) || input.is_a?(FalseClass)
        end

        def date?(input)
          input.is_a?(Date)
        end

        def date_time?(input)
          input.is_a?(DateTime)
        end

        def time?(input)
          input.is_a?(Time)
        end

        def number?(input)
          begin
            true if Float(input)
          rescue ArgumentError, TypeError
            false
          end
        end

        def int?(input)
          input.is_a?(Fixnum)
        end

        def float?(input)
          input.is_a?(Float)
        end

        def decimal?(input)
          input.is_a?(BigDecimal)
        end

        def str?(input)
          input.is_a?(String)
        end

        def hash?(input)
          input.is_a?(Hash)
        end

        def array?(input)
          input.is_a?(Array)
        end

        def odd?(input)
          input.odd?
        end

        def even?(input)
          input.even?
        end

        def lt?(num, input)
          input < num
        end

        def gt?(num, input)
          input > num
        end

        def lteq?(num, input)
          !self[:gt?].(num, input)
        end

        def gteq?(num, input)
          !self[:lt?].(num, input)
        end

        def size?(size, input)
          case size
          when Fixnum then size == input.size
          when Range, Array then size.include?(input.size)
          else
            raise ArgumentError, "+#{size}+ is not supported type for size? predicate."
          end
        end

        def min_size?(num, input)
          input.size >= num
        end

        def max_size?(num, input)
          input.size <= num
        end

        def inclusion?(list, input)
          ::Kernel.warn 'inclusion is deprecated - use included_in instead.'
          self[:included_in?].(list, input)
        end

        def exclusion?(list, input)
          ::Kernel.warn 'exclusion is deprecated - use excluded_from instead.'
          self[:excluded_from?].(list, input)
        end

        def included_in?(list, input)
          list.include?(input)
        end

        def excluded_from?(list, input)
          !list.include?(input)
        end

        def includes?(value, input)
          begin
            if input.respond_to?(:include?)
              input.include?(value)
            else
              false
            end
          rescue TypeError
            false
          end
        end

        def excludes?(value, input)
          !self[:includes?].(value, input)
        end

        def eql?(left, right)
          left.eql?(right)
        end

        def not_eql?(left, right)
          !left.eql?(right)
        end

        def true?(value)
          value.equal?(true)
        end

        def false?(value)
          value.equal?(false)
        end

        def format?(regex, input)
          !regex.match(input).nil?
        end

        def predicate(name, &block)
          define_singleton_method(name, &block)
        end
      end

      extend Methods

      def self.included(other)
        super
        other.extend(Methods)
      end
    end
  end
end
