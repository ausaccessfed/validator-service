# frozen_string_literal: true
FactoryGirl.define do
  factory :api_subject do
    x509_cn { Faker::Lorem.words.join }
    description { Faker::Lorem.paragraph }
    contact_name { Faker::Name.name }
    contact_mail { Faker::Internet.email }
    enabled { true }
  end
end
