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
  has_many :posts
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

puts "=== tweet1 ==="
FactoryBot.create(:tweet1)

puts "=== tweet2 ==="
FactoryBot.create(:tweet2)

puts "=== tweet3 ==="
FactoryBot.create(:tweet3)

puts "=== tweet4 ==="
FactoryBot.create(:tweet4)
