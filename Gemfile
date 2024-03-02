# frozen_string_literal: true
source 'https://rubygems.org'

github_url = 'https://rubygems.pkg.github.com/tastyworks/'
source github_url do
  gem 'tastyworks-apex', '~> 19.20'
  gem 'tastyworks-api', '~> 12.1'
  gem 'tastyworks-grape', '~> 15.0'

  group 'development', 'test' do
    gem 'tastyworks-development_dependencies', '~> 2.35'
  end

  group 'test' do
    gem 'tastyworks-test_dependencies', '~> 1.12'
  end
end

gem "async", "~> 2.8"

gem "async-http", "~> 0.63.0"
