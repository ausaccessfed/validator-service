# frozen_string_literal: true

FactoryGirl.define do
  factory :api_subject do
    x509_cn { Faker::Lorem.words.join }
    description { Faker::Lorem.paragraph }
    contact_name { Faker::Name.name }
    contact_mail { Faker::Internet.email }
    enabled { true }
  end

  trait :authorized do
    transient { permission '*' }

    after(:create) do |api_subject, attrs|
      role = create :role
      permission = create :permission, value: attrs.permission, role: role
      role.permissions << permission
      role.api_subjects << api_subject
    end
  end
end
