# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word }
    entitlement do
      "urn:mace:x-aaf:dev:ide:#{Faker::Lorem.words(number: 4).join(':')}"
    end
  end
end
