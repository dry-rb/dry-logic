# frozen_string_literal: true

module Dry
  module Logic
    module Build
      class Base < BasicObject
        def self.call(&block)
          new.instance_eval(&block)
        end

        def self.const_missing(name)
          ::Object.const_get(name)
        end
      end
    end
  end
end
