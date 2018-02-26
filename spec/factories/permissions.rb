# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    value { Faker::Lorem.word }
    role { FactoryBot.create(:role) }
  end
end
