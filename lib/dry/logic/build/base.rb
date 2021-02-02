# frozen_string_literal: true
require "dry/core/memoizable"

module Dry
  module Logic
    module Build
      class Base
        include Dry::Core::Memoizable

        # As to prevent overlap with {Predicates::Methods}
        # Alternativly {Base} can inherit from {BasicObject}
        # but {Dry::Core::Memoizable} doesn't (currently)
        # support {BasicObject} inherited classes
        undef :eql?, :respond_to?, :nil?

        def self.call(&block)
          new.instance_eval(&block)
        end
      end
    end
  end
end
