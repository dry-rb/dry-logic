require 'dry/equalizer'
require 'dry/logic/operators'
require 'dry/logic/applicable'

module Dry
  module Logic
    module Operations
      class Abstract
        include Dry::Equalizer(:rules, :options)
        include Operators
        include Applicable

        attr_reader :rules

        attr_reader :options

        def initialize(*rules, **options)
          super
          @rules = rules.flatten
          @options = options
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
