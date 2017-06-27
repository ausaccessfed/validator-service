# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    name Faker::Commerce.department
    enabled true
    order 1
  end
end
