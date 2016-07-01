# frozen_string_literal: true
FactoryGirl.define do
  idp_domain = Faker::Internet.domain_name
  idp = "https://idp.#{idp_domain}/idp/shibboleth"
  sp = "https://sp.#{Faker::Internet.domain_name}/shibboleth"
  name = Faker::Name.name
  valid_affiliations = [
    'faculty',
    'student',
    'staff',
    'employee',
    'member',
    'affiliate',
    'alum',
    'library-walk-in'
  ]

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
      rand(2...10).times do
        affiliations << valid_affiliations.sample
      end
      affiliations
    end
    scoped_affiliation do
      scoped_affiliations = []
      rand(2...10).times do
        scoped_affiliations << "#{valid_affiliations.sample}@#{idp_domain}"
      end
      scoped_affiliations
    end
    initialize_with { attributes }
  end

  factory :shib_env, class: Hash do
    env do
      {
        'SCRIPT_NAME' => '/auth',
        'QUERY_STRING' => 'identity=CZa_1pvgsbWD_IzNsAR7d7jaGcs',
        'SERVER_PROTOCOL' => 'HTTP/1.1',
        'SERVER_SOFTWARE' => 'puma 3.4.0 Owl Bowl Brawl',
        'GATEWAY_INTERFACE' => 'CGI/1.2',
        'REQUEST_METHOD' => 'GET',
        'REQUEST_PATH' => '/auth/login',
        'REQUEST_URI' => '/auth/login?identity=CZa',
        'HTTP_VERSION' => 'HTTP/1.1',
        'HTTP_HOST' => 'localhost:3000',
        'HTTP_CONNECTION' => 'keep-alive',
        'HTTP_CACHE_CONTROL' => 'max-age=0',
        'HTTP_UPGRADE_INSECURE_REQUESTS' => '1',
        'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 1)' \
          ' AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103' \
          ' Safari/537.36',
        'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,' \
          'application/xml;q=0.9,image/webp,*/*;q=0.8',
        'HTTP_ACCEPT_ENCODING' => 'gzip, deflate, sdch',
        'HTTP_ACCEPT_LANGUAGE' => 'en-US,en;q=0.8',
        'HTTP_COOKIE' => 'cookie, num, num, num',
        'SERVER_NAME' => 'localhost',
        'SERVER_PORT' => '3000',
        'PATH_INFO' => '/login',
        'REMOTE_ADDR' => '::1',
        'ROUTES_70279184121340_SCRIPT_NAME' => '',
        'ORIGINAL_FULLPATH' => '/auth/login?identity=CZa',
        'ORIGINAL_SCRIPT_NAME' => '',
        'ROUTES_70279169814040_SCRIPT_NAME' => '/auth',
        'HTTP_TARGETED_ID' => 'https://idp.ernser.example.edu/idp/' \
          'shibboleth!https://sp.example.edu/' \
          'shibboleth!17865674-60c1-4202-aef9-21d4e66338d6',
        'HTTP_AUEDUPERSONSHAREDTOKEN' => 'CZa',
        'HTTP_DISPLAYNAME' => 'Jefferey Kohler',
        'HTTP_CN' => 'Jefferey Kohler',
        'HTTP_PRINCIPALNAME' => 'kohlerj@ernser.example.edu',
        'HTTP_MAIL' => 'jefferey.kohler@ernser.example.edu',
        'HTTP_O' => 'Southern Ernser University',
        'HTTP_HOMEORGANIZATION' => 'ernser.example.edu',
        'HTTP_HOMEORGANIZATIONTYPE' => 'urn:mace:terena.org:schac:' \
          'homeOrganizationType:au:university',
        'HTTP_EDUPERSONAFFILIATION' => 'staff;member',
        'HTTP_EDUPERSONSCOPEDAFFILIATION' => 'staff@ernser.example.edu;' \
          'member@ernser.example.edu'
      }
    end
  end
end
