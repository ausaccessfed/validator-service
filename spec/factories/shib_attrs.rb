# frozen_string_literal: true
FactoryGirl.define do
  idp_domain = 'arcs.org.au' # Faker::Internet.domain_name
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
    home_organization { Faker::Internet.domain_name }
    home_organization_type do
      'urn:mace:terena.org:schac:homeOrganizationType:au:university'
    end
    affiliation do
      affiliations = []
      valid_affiliations = [
        'faculty',
        'student',
        'staff',
        'employee',
        'member',
        'affiliate',
        'alum',
        'library-walk-in']
      rand(2...10).times do
        affiliations << valid_affiliations.sample
      end
      affiliations
    end
    scoped_affiliation do
      scoped_affiliations = []
      rand(2...10).times do
        scoped_affiliations << Faker::Internet.email
      end
      scoped_affiliations
    end
    initialize_with { attributes }
  end
end
