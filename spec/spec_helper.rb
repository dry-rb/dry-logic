# frozen_string_literal: true

require_relative "support/coverage"
require_relative "support/warnings"

require "dry/logic"
require "pathname"

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join("shared/**/*.rb")].each(&method(:require))
Dir[SPEC_ROOT.join("support/**/*.rb")].each(&method(:require))

RSpec.configure do |config|
  config.include Module.new {
    def undefined
      Dry::Core::Constants::Undefined
    end
  }
end
