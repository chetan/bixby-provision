
source "https://rubygems.org"

group :self do
  gem 'bixby-provision', :path => "."
end

gem "bixby-client"
# gem "bixby-client", :path => "../client"
gem "api-auth", :github => "chetan/api_auth", :branch => "bixby"
gem "mixlib-shellout", "~> 1.3.0"

# required by various DSLs
gem "git", "~> 1.2.6"
gem "tilt", "~> 2.0"

group :development do
  # packaging
  gem 'jeweler', :github => "chetan/jeweler", :branch => "bixby"
  gem 'yard', '~> 0.7'

  # debugging
  gem 'pry'
  gem 'awesome_print'

  # tools
  gem "test_guard", :github => "chetan/test_guard"
  gem "micron", :github => "chetan/micron"
end
