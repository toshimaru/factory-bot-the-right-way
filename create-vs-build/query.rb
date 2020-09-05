# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "activerecord"
  gem "factory_bot", "6.1.0"
  gem "sqlite3"
end

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.timestamps
  end
end

class User < ActiveRecord::Base
end

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name)  { |n| "last_name#{n}" }
  end
end

puts "=== Create ==="
FactoryBot.create(:user)

puts "=== Build ==="
FactoryBot.build(:user)
