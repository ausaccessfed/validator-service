# frozen_string_literal: true
FactoryGirl.define do
  factory :subject do
    name { Faker::Name.name }
    mail { Faker::Internet.email }
    enabled { true }
    complete { true }
  end
end
