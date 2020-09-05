require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "factory_bot", "6.1.0"
  gem "activerecord"
  gem "rspec"
  gem "sqlite3"
end

require 'active_record'

ActiveRecord::Base.establish_copnnection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
  end
end

class User < ActiveRecord::Base
end

FactoryBot.define do
  factory :user do
  end
end

user = FactoryBot.create(:user)
p user
