# frozen_string_literal: true

FederationAttribute.destroy_all

FederationAttribute.create(
  name: 'targeted_id',
  http_header: 'HTTP_TARGETED_ID'
)

FederationAttribute.create(
  name: 'shared_token',
  http_header: 'HTTP_AUEDUPERSONSHAREDTOKEN'
)

FederationAttribute.create(
  name: 'principal_name',
  http_header: 'HTTP_PRINCIPALNAME'
)

FederationAttribute.create(
  name: 'name',
  http_header: 'HTTP_DISPLAYNAME'
)

FederationAttribute.create(
  name: 'display_name',
  http_header: 'HTTP_DISPLAYNAME'
)

FederationAttribute.create(
  name: 'cn',
  http_header: 'HTTP_CN'
)

FederationAttribute.create(
  name: 'mail',
  http_header: 'HTTP_MAIL'
)

FederationAttribute.create(
  name: 'o',
  http_header: 'HTTP_O'
)

FederationAttribute.create(
  name: 'home_organization',
  http_header: 'HTTP_HOMEORGANIZATION'
)

FederationAttribute.create(
  name: 'home_organization_type',
  http_header: 'HTTP_HOMEORGANIZATIONTYPE'
)

FederationAttribute.create(
  name: 'affiliation',
  http_header: 'HTTP_EDUPERSONAFFILIATION',
  singular: false
)

FederationAttribute.create(
  name: 'scoped_affiliation',
  http_header: 'HTTP_EDUPERSONSCOPEDAFFILIATION',
  singular: false
)
