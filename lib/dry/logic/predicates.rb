require 'bigdecimal'
require 'bigdecimal/util'
require 'date'

module Dry
  module Logic
    module Predicates
      def self.[](name)
        method(name)
      end

      def self.type?(type, input)
        input.kind_of?(type)
      end

      def self.none?(input)
        input.nil?
      end

      def self.key?(name, input)
        input.key?(name)
      end

      def self.attr?(name, input)
        input.respond_to?(name)
      end

      def self.empty?(input)
        case input
        when String, Array, Hash then input.empty?
        when nil then true
        else
          false
        end
      end

      def self.filled?(input)
        !self[:empty?].(input)
      end

      def self.bool?(input)
        input.is_a?(TrueClass) || input.is_a?(FalseClass)
      end

      def self.date?(input)
        input.is_a?(Date)
      end

      def self.date_time?(input)
        input.is_a?(DateTime)
      end

      def self.time?(input)
        input.is_a?(Time)
      end

      def self.number?(input)
        begin
          true if Float(input)
        rescue ArgumentError, TypeError
          false
        end
      end

      def self.int?(input)
        input.is_a?(Fixnum)
      end

      def self.float?(input)
        input.is_a?(Float)
      end

      def self.decimal?(input)
        input.is_a?(BigDecimal)
      end

      def self.str?(input)
        input.is_a?(String)
      end

      def self.hash?(input)
        input.is_a?(Hash)
      end

      def self.array?(input)
        input.is_a?(Array)
      end

      def self.odd?(input)
        input.odd?
      end

      def self.even?(input)
        input.even?
      end

      def self.lt?(num, input)
        input < num
      end

      def self.gt?(num, input)
        input > num
      end

      def self.lteq?(num, input)
        !self[:gt?].(num, input)
      end

      def self.gteq?(num, input)
        !self[:lt?].(num, input)
      end

      def self.size?(size, input)
        case size
        when Fixnum then size == input.size
        when Range, Array then size.include?(input.size)
        else
          raise ArgumentError, "+#{size}+ is not supported type for size? predicate."
        end
      end

      def self.min_size?(num, input)
        input.size >= num
      end

      def self.max_size?(num, input)
        input.size <= num
      end

      def self.inclusion?(list, input)
        ::Kernel.warn 'inclusion is deprecated - use included_in instead.'
        self[:included_in?].(list, input)
      end

      def self.exclusion?(list, input)
        ::Kernel.warn 'exclusion is deprecated - use excluded_from instead.'
        self[:excluded_from?].(list, input)
      end

      def self.included_in?(list, input)
        list.include?(input)
      end

      def self.excluded_from?(list, input)
        !list.include?(input)
      end

      def self.includes?(value, input)
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

      def self.excludes?(value, input)
        !self[:includes?].(value, input)
      end

      def self.eql?(left, right)
        left.eql?(right)
      end

      def self.not_eql?(left, right)
        !left.eql?(right)
      end

      def self.true?(value)
        value === true
      end

      def self.false?(value)
        value === false
      end

      def self.format?(regex, input)
        !regex.match(input).nil?
      end
    end
  end
end
