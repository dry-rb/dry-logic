# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

begin
  require 'pry-byebug'
rescue LoadError; end

require 'dry-logic'
require 'dry/core/constants'
require 'pathname'

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join('shared/**/*.rb')].each(&method(:require))
Dir[SPEC_ROOT.join('support/**/*.rb')].each(&method(:require))

include Dry::Logic
include Dry::Core::Constants

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.warnings = true
end
