# frozen_string_literal: true
FactoryGirl.define do
  name = Faker::Lorem.word
  factory :federation_attribute do
    name { name }
    regexp { Faker::Lorem.word }
    regexp_triggers_failure { Faker::Boolean.boolean }
    description { Faker::Lorem.paragraph }
    documentation_url { Faker::Internet.url }
    singular { Faker::Boolean.boolean }
    http_header { "HTTP_#{name.upcase}" }
  end
end
