# frozen_string_literal: true

FederationAttribute.destroy_all

core = Category.create(
  name: 'Core Attributes',
  description: 'AAF Core Attributes.',
  enabled: true,
  order: 1
)

optional = Category.create(
  name: 'Optional Attributes',
  description: 'AAF Optional Attributes.',
  enabled: true,
  order: 2
)

# Core attributes

FederationAttribute.create(
  name: 'auEduPersonSharedToken',
  http_header: 'HTTP_AUEDUPERSONSHAREDTOKEN',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'authenticationMethod',
  http_header: 'HTTP_AUTHENTICATIONMETHOD',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'cn',
  http_header: 'HTTP_CN',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'displayName',
  http_header: 'HTTP_DISPLAYNAME',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'eduPersonAffiliation',
  http_header: 'HTTP_EDUPERSONAFFILIATION',
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'eduPersonAssurance',
  http_header: 'HTTP_EDUPERSONASSURANCE',
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'eduPersonEntitlement',
  http_header: 'HTTP_EDUPERSONENTITLEMENT',
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'eduPersonScopedAffiliation',
  http_header: 'HTTP_EDUPERSONSCOPEDAFFILIATION',
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'eduPersonTargetedID',
  http_header: 'HTTP_TARGETED_ID',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'mail',
  http_header: 'HTTP_MAIL',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create(
  name: 'o',
  http_header: 'HTTP_O',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

# Optional

FederationAttribute.create(
  name: 'businessCategory',
  http_header: 'HTTP_BUSINESSCATEGORY',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'departmentNumber',
  http_header: 'HTTP_DEPARTMENTNUMBER',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'division',
  http_header: 'HTTP_DIVISION',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'eduPersonOrcid',
  http_header: 'HTTP_EDUPERSONORCID',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'givenName',
  http_header: 'HTTP_GIVENNAME',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'mobileNumber',
  http_header: 'HTTP_MOBILENUMBER',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]

)

FederationAttribute.create(
  name: 'organizationalUnit',
  http_header: 'HTTP_ORGANIZATIONALUNIT',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'postalAddress',
  http_header: 'HTTP_POSTALADDRESS',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'schacHomeOrganization',
  http_header: 'HTTP_HOMEORGANIZATION',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'schacHomeOrganizationType',
  http_header: 'HTTP_HOMEORGANIZATIONTYPE',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'surname',
  http_header: 'HTTP_SURNAME',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'sn',
  http_header: 'HTTP_SN',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create(
  name: 'telephoneNumber',
  http_header: 'HTTP_TELEPHONENUMBER',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

# Other

FederationAttribute.create(
  name: 'eduPersonPrincipalName',
  http_header: 'HTTP_PRINCIPALNAME'
)
