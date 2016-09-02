require 'dry/equalizer'
require 'dry/logic/operators'
require 'dry/logic/appliable'

module Dry
  module Logic
    module Operations
      class Abstract
        include Dry::Equalizer(:rules, :options)
        include Operators
        include Appliable

        attr_reader :rules

        attr_reader :options

        def initialize(*rules, **options)
          @rules = rules
          @options = options
        end

        def curry(*args)
          new(rules.map { |rule| rule.curry(*args) }, options)
        end

        def new(rules, **new_options)
          self.class.new(*rules, options.merge(new_options))
        end

        def with(new_options)
          new(rules, options.merge(new_options))
        end
      end
    end
  end
end
