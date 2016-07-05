# frozen_string_literal: true

FederationAttribute.destroy_all

# Core attributes

FederationAttribute.create(
  name: 'auEduPersonSharedToken',
  http_header: 'HTTP_AUEDUPERSONSHAREDTOKEN'
)

FederationAttribute.create(
  name: 'authenticationMethod',
  http_header: 'HTTP_AUTHENTICATIONMETHOD'
)

FederationAttribute.create(
  name: 'cn',
  http_header: 'HTTP_CN'
)

FederationAttribute.create(
  name: 'displayName',
  http_header: 'HTTP_DISPLAYNAME'
)

FederationAttribute.create(
  name: 'eduPersonAffiliation',
  http_header: 'HTTP_EDUPERSONAFFILIATION',
  singular: false
)

FederationAttribute.create(
  name: 'eduPersonAssurance',
  http_header: 'HTTP_EDUPERSONASSURANCE',
  singular: false
)

FederationAttribute.create(
  name: 'eduPersonEntitlement',
  http_header: 'HTTP_EDUPERSONENTITLEMENT',
  singular: false
)

FederationAttribute.create(
  name: 'eduPersonScopedAffiliation',
  http_header: 'HTTP_EDUPERSONSCOPEDAFFILIATION',
  singular: false
)

FederationAttribute.create(
  name: 'eduPersonTargetedID',
  http_header: 'HTTP_TARGETED_ID'
)

FederationAttribute.create(
  name: 'mail',
  http_header: 'HTTP_MAIL'
)

FederationAttribute.create(
  name: 'o',
  http_header: 'HTTP_O'
)

# Optional

FederationAttribute.create(
  name: 'givenName',
  http_header: 'HTTP_GIVENNAME'
)

FederationAttribute.create(
  name: 'mobileNumber',
  http_header: 'HTTP_MOBILENUMBER'
)

FederationAttribute.create(
  name: 'organizationalUnit',
  http_header: 'HTTP_ORGANIZATIONALUNIT'
)

FederationAttribute.create(
  name: 'postalAddress',
  http_header: 'HTTP_POSTALADDRESS'
)

FederationAttribute.create(
  name: 'schacHomeOrganization',
  http_header: 'HTTP_HOMEORGANIZATION'
)

FederationAttribute.create(
  name: 'schacHomeOrganizationType',
  http_header: 'HTTP_HOMEORGANIZATIONTYPE'
)

FederationAttribute.create(
  name: 'surname',
  http_header: 'HTTP_SURNAME'
)

FederationAttribute.create(
  name: 'telephoneNumber',
  http_header: 'HTTP_TELEPHONENUMBER'
)

# Other

FederationAttribute.create(
  name: 'eduPersonPrincipalName',
  http_header: 'HTTP_PRINCIPALNAME'
)
