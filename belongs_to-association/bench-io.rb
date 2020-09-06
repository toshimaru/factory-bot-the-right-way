# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "activerecord"
  gem "benchmark-ips"
  gem "factory_bot", "6.1.0"
  gem "sqlite3"
end

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: 'belongsto-association-bench.sqlite3')
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.timestamps
  end

  create_table :tweets do |t|
    t.references :user, null: false
    t.string :content
    t.timestamps
  end
end

class User < ActiveRecord::Base
  has_many :tweets
end

class Tweet < ActiveRecord::Base
  belongs_to :user
end

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name)  { |n| "last_name#{n}" }
  end
  factory :tweet1, class: "Tweet" do
    user
    sequence(:content) { |n| "My Tweet Content #{n}." }
  end
  factory :tweet2, class: "Tweet" do
    user { create(:user) }
    sequence(:content) { |n| "My Tweet Content #{n}." }
  end
  factory :tweet3, class: "Tweet" do
    user { build(:user) }
    sequence(:content) { |n| "My Tweet Content #{n}." }
  end
  factory :tweet4, class: "Tweet" do
    after(:build) { |tweet| tweet.user = build(:user) }
    sequence(:content) { |n| "My Tweet Content #{n}." }
  end
end

require 'benchmark/ips'
Benchmark.ips do |x|
  x.report("FactoryBot.build tweet1") { FactoryBot.build(:tweet1) }
  x.report("FactoryBot.build tweet2") { FactoryBot.build(:tweet2) }
  x.report("FactoryBot.build tweet3") { FactoryBot.build(:tweet3) }
  x.report("FactoryBot.build tweet4") { FactoryBot.build(:tweet4) }
  x.compare!
end
