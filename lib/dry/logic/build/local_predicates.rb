require "dry/logic/predicates"

module Dry
  module Logic
    module Build
      # This module is used to prevent {Predicates::Methods.predicate}
      # from adding custom, user defined methods to the global scope
      module LocalPredicates
        include Dry::Logic::Predicates
      end
    end
  end
end
