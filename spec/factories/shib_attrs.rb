# frozen_string_literal: true

FactoryBot.define do
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
  token = SecureRandom.urlsafe_base64(20)

  factory :shib_env, class: Hash do
    env do
      scoped_affiliation = "#{valid_affiliations.sample}@#{idp_domain}"

      {
        'SCRIPT_NAME' => '/auth',
        'QUERY_STRING' => "identity=#{token}",
        'SERVER_PROTOCOL' => 'HTTP/1.1',
        'SERVER_SOFTWARE' => 'puma 3.4.0 Owl Bowl Brawl',
        'GATEWAY_INTERFACE' => 'CGI/1.2',
        'REQUEST_METHOD' => 'GET',
        'REQUEST_PATH' => '/auth/login',
        'REQUEST_URI' => "/auth/login?identity=#{token}",
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
        'ORIGINAL_FULLPATH' => "/auth/login?identity=#{token}",
        'ORIGINAL_SCRIPT_NAME' => '',
        'ROUTES_70279169814040_SCRIPT_NAME' => '/auth',
        'HTTP_PERSISTENT_ID' => "#{idp}!#{sp}!#{SecureRandom.uuid}",
        'HTTP_TARGETED_ID' => "#{idp}!#{sp}!#{SecureRandom.uuid}",
        'HTTP_AUEDUPERSONSHAREDTOKEN' => token,
        'HTTP_DISPLAYNAME' => name,
        'HTTP_CN' => name,
        'HTTP_EPPN' => name,
        'HTTP_MAIL' => Faker::Internet.email,
        'HTTP_O' => Faker::Company.name,
        'HTTP_HOMEORGANIZATION' => Faker::Internet.domain_name,
        'HTTP_HOMEORGANIZATIONTYPE' => 'urn:mace:terena.org:schac:' \
          'homeOrganizationType:au:university',
        'HTTP_UNSCOPED_AFFILIATION' => valid_affiliations.sample,
        'HTTP_SCOPED_AFFILIATION' => scoped_affiliation
      }
    end
  end
end
