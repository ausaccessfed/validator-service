# frozen_string_literal: true
FactoryGirl.define do
  factory :federation_attribute_alias do
    name { Faker::Lorem.word }
  end
end
