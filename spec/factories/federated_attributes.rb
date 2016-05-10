# frozen_string_literal: true
FactoryGirl.define do
  factory :federation_attribute do
    name { Faker::Lorem.word }
    regexp { Faker::Lorem.word }
    regexp_triggers_failure { Faker::Boolean.boolean }
    description { Faker::Lorem.paragraph }
    documentation_url { Faker::Internet.url }
    singular { Faker::Boolean.boolean }
  end
end
