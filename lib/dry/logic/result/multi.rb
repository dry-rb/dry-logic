module Dry
  module Logic
    class Result::Multi < Result
      def success?
        success.all?(&:success?)
      end

      def failures
        indices = success.map { |v| v.failure? ? success.index(v) : nil }.compact
        success.values_at(*indices)
      end
    end
  end
end
