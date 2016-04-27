# frozen_string_literal: true
FactoryGirl.define do

  idp_domain = Faker::Internet.domain_name
  idp = "https://idp.#{idp_domain}/idp/shibboleth"
  sp = "https://sp.#{Faker::Internet.domain_name}/shibboleth"
  name = Faker::Name.name

  factory :subject do
    name { Faker::Name.name }
    mail { Faker::Internet.email }

    shared_token { SecureRandom.urlsafe_base64(20) }
    targeted_id { "#{idp}!#{sp}!#{SecureRandom.uuid}" }
    principal_name { "#{name}" }
    display_name { "#{name}" }
    cn { "#{name}" }
    o { Faker::Company.name }
    home_organization { "ernser.example.edu" }
    home_organization_type { "urn:mace:terena.org:schac:homeOrganizationType:au:university" }

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
