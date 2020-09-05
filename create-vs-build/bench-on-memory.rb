# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "activerecord"
  gem "benchmark-ips"
  gem "factory_bot", "6.1.0"
  gem "rspec"
  gem "sqlite3"
end

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
# ActiveRecord::Base.logger = Logger.new(STDOUT)
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
    first_name { "first_name#{id}" }
    last_name  { "last_name#{id}" }
  end
end

require 'benchmark/ips'
Benchmark.ips do |x|
  x.report("FactoryBot.create") {
    FactoryBot.create(:user)
  }
  x.report("FactoryBot.build") {
    FactoryBot.build(:user)
  }
  x.compare!
end
