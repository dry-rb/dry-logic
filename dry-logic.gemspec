# frozen_string_literal: true

require File.expand_path('../lib/dry/logic/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'dry-logic'
  spec.version       = Dry::Logic::VERSION
  spec.authors       = ['Piotr Solnica']
  spec.email         = ['piotr.solnica@gmail.com']
  spec.summary       = 'Predicate logic with rule composition'
  spec.homepage      = 'https://github.com/dry-rb/dry-logic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4.0'

  spec.metadata = {
    'source_code_uri' => 'https://github.com/dry-rb/dry-logic',
    'changelog_uri' => 'https://github.com/dry-rb/dry-logic/blob/master/CHANGELOG.md'
  }

  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'dry-core', '~> 0.2'
  spec.add_runtime_dependency 'dry-equalizer', '~> 0.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
