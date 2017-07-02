# frozen_string_literal: true

FactoryGirl.define do
  factory :permission do
    value { Faker::Lorem.word }
    role { FactoryGirl.create(:role) }
  end
end
