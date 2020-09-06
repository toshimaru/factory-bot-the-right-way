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

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
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

    trait :with_tweets1 do
      after(:create) do |user|
        user.tweets << create(:tweet)
      end
    end

    trait :with_tweets2 do
      after(:create) do |user|
        create(:tweet, user: user)
      end
    end

    trait :with_tweets3 do
      tweets { [association(:tweet)] }
    end

    trait :with_tweets4 do
      tweets { [build(:tweet)] }
    end
  end

  factory :tweet do
    user
    sequence(:content) { |n| "My Tweet Content #{n}." }
  end
end

require 'benchmark/ips'
Benchmark.ips do |x|
  x.report("FactoryBot.create with_tweets1") { FactoryBot.create(:user, :with_tweets1) }
  x.report("FactoryBot.create with_tweets2") { FactoryBot.create(:user, :with_tweets2) }
  x.report("FactoryBot.create with_tweets3") { FactoryBot.create(:user, :with_tweets3) }
  x.report("FactoryBot.create with_tweets4") { FactoryBot.create(:user, :with_tweets4) }
  x.compare!
end
Benchmark.ips do |x|
  x.report("FactoryBot.build with_tweets1") { FactoryBot.build(:user, :with_tweets1) }
  x.report("FactoryBot.build with_tweets2") { FactoryBot.build(:user, :with_tweets2) }
  x.report("FactoryBot.build with_tweets3") { FactoryBot.build(:user, :with_tweets3) }
  x.report("FactoryBot.build with_tweets4") { FactoryBot.build(:user, :with_tweets4) }
  x.compare!
end
