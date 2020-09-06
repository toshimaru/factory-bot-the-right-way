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

puts "=== with_tweets1 ==="
FactoryBot.create(:user, :with_tweets1)
puts "=== with_tweets2 ==="
FactoryBot.create(:user, :with_tweets2)
puts "=== with_tweets3 ==="
FactoryBot.create(:user, :with_tweets3)
puts "=== with_tweets4 ==="
FactoryBot.create(:user, :with_tweets4)
