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

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: 'always-create-association.sqlite3')
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.timestamps
  end

  create_table :posts do |t|
    t.references :user, null: false
    t.string :title
    t.timestamps
  end
end

class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name)  { |n| "last_name#{n}" }
  end
  factory :post, class: "Post" do
    title { "Through the Looking Glass" }
    user
  end
  factory :always_create_post, class: "Post" do
    title { "Through the Looking Glass" }
    user { create(:user) }
  end
end

require 'benchmark/ips'
Benchmark.ips do |x|
  x.report("FactoryBot.build post") { FactoryBot.build(:post) }
  x.report("FactoryBot.build always_create_post") { FactoryBot.build(:always_create_post) }
  x.compare!
end
