require 'dry/logic/operators'

module Dry
  module Logic
    module Operations
      class Abstract
        include Dry::Equalizer(:rules)
        include Operators

        attr_reader :rules

        attr_reader :result

        attr_reader :options

        def initialize(*rules, **options)
          @rules = rules.flatten
          @options = options
          @result = options[:result]
        end

        def applied?
          !result.nil?
        end

        def success?
          result.equal?(true)
        end

        def failure?
          !success?
        end

        def curry(*args)
          self.class.new(rules.map { |rule| rule.curry(*args) }, options)
        end

        def new(rules, new_options)
          self.class.new(rules, options.merge(new_options))
        end

        def with(new_options)
          self.class.new(*rules, options.merge(new_options))
        end
      end
    end
  end
end
