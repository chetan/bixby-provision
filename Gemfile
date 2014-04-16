
source "https://rubygems.org"

group :self do
  gem 'bixby-provision', :path => "."
end

gem "bixby-client"
# gem "bixby-client", :path => "~/work/bixby/client"
gem "api-auth", :github => "chetan/api_auth", :branch => "bixby"
gem "git", "~> 1.2.6"

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
