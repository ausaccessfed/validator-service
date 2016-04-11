# frozen_string_literal: true
FactoryGirl.define do
  factory :subject do
    name { Faker::Name.name }
    mail { Faker::Internet.email }
    enabled { true }
    complete { true }

    trait :authorized do
      transient { permission '*' }

      after(:create) do |subject, attrs|
        role = create :role
        permission = create :permission, value: attrs.permission, role: role
        role.permissions << permission
        role.subjects << subject
      end
    end
  end
end
