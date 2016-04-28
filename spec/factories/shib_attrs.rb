# frozen_string_literal: true
FactoryGirl.define do
  factory :shib_attrs, class: Hash do

    shared_token "CZa_1pvgsbWD_IzNsAR7d7jaGcs"
    targeted_id "https//idp.ernser.example.edu/idp/shibboleth!https//sp.example.edu/shibboleth!17865674-60c1-4202-aef9-21d4e66338d6"
    principal_name "kohlerj@ernser.example.edu"
    name "Jefferey Kohler"
    display_name "Jefferey Kohler"
    cn "Jefferey Kohler"
    mail "jefferey.kohler@ernser.example.edu"
    o "Southern Ernser University"
    home_organization "ernser.example.edu"
    home_organization_type "urnmaceterena.orgschachomeOrganizationTypeauuniversity"
    affiliation ["staff", "member"]
    scoped_affiliation ["staff@ernser.example.edu", "member@ernser.example.edu"]

    initialize_with { attributes }

  end
end
