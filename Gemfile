source 'https://rubygems.org'

gemspec

group :test do
  gem 'codeclimate-test-reporter', platform: :mri
end

group :tools do
  gem 'byebug', platform: :mri
  gem 'simplecov', platforms: :mri

  unless ENV['TRAVIS']
    gem 'mutant', github: 'mbj/mutant'
    gem 'mutant-rspec', github: 'mbj/mutant'
  end
end
