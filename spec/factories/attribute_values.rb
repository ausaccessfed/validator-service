# frozen_string_literal: true

FactoryBot.define do
  factory :attribute_value do
    value { Faker::Lorem.word }
  end
end
