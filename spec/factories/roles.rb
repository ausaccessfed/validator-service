# frozen_string_literal: true
FactoryGirl.define do
  factory :role do
    name { Faker::Lorem.word }
  end
end
