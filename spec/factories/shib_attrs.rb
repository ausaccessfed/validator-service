# frozen_string_literal: true
FactoryGirl.define do

  idp_domain = Faker::Internet.domain_name
  idp = "https://idp.#{idp_domain}/idp/shibboleth"
  sp = "https://sp.#{Faker::Internet.domain_name}/shibboleth"
  name = Faker::Name.name

  factory :shib_attrs, class: Hash do

    shared_token { SecureRandom.urlsafe_base64(20) }
    targeted_id { "#{idp}!#{sp}!#{SecureRandom.uuid}" }
    principal_name { name }
    name { name }
    display_name { name }
    cn { name }
    mail { Faker::Internet.email }
    o { Faker::Company.name }
    home_organization { "ernser.example.edu" }
    home_organization_type do
      "urnmaceterena.orgschachomeOrganizationTypeauuniversity"
    end
    affiliation { ["staff", "member"] }
    scoped_affiliation do
      ["staff@ernser.example.edu", "member@ernser.example.edu"]
    end

    initialize_with { attributes }

  end
end
