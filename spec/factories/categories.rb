# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    enabled { true }
    order { 1 }
  end
end
