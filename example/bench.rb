require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "factory_bot", "6.1.0"
  gem "sqlite3"
end

p FactoryBot
