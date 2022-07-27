# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

gem "dry-core", github: "dry-rb/dry-core", branch: "main"

group :tools do
  gem "benchmark-ips", platform: :mri
  gem "hotch", platform: :mri
  gem "pry-byebug", platform: :mri
end
