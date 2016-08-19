module Dry
  module Logic
    Undefined = Class.new {
      def inspect
        "undefined"
      end
      alias_method :to_s, :inspect
    }.new.freeze
  end
end
