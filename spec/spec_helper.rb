if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.3.1'
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

begin
  require 'byebug'
rescue LoadError; end

require 'dry-logic'
require 'pathname'

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join('shared/**/*.rb')].each(&method(:require))
Dir[SPEC_ROOT.join('support/**/*.rb')].each(&method(:require))

include Dry::Logic

RSpec.configure do |config|
  config.disable_monkey_patching!
end
