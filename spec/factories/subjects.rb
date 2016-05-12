# frozen_string_literal: true
FactoryGirl.define do
  idp_domain = Faker::Internet.domain_name
  idp = "https://idp.#{idp_domain}/idp/shibboleth"
  sp = "https://sp.#{Faker::Internet.domain_name}/shibboleth"

  factory :subject do
    name { Faker::Name.name }
    mail { Faker::Internet.email }
    targeted_id { "#{idp}!#{sp}!#{SecureRandom.uuid}" }

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
