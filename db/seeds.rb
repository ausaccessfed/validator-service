# frozen_string_literal: true

FederationAttribute.destroy_all

core = Category.create!(
  name: 'AAF Core Attributes',
  description: 'AAF Core Attributes.',
  enabled: true,
  order: 1
)

optional = Category.create!(
  name: 'AAF Optional Attributes',
  description: 'AAF Optional Attributes.',
  enabled: true,
  order: 2
)

# Core attributes

faa = FederationAttributeAlias.create!(
  name: 'auEduPersonSharedToken'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.27856.1.2.5',
  internal_alias: 'auedupersonsharedtoken',
  http_header: 'HTTP_AUEDUPERSONSHAREDTOKEN',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_AUTHENTICATIONMETHOD',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'authenticationMethod'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: true, category: core)
#   ]
# )

faas = %w(
  cn
  commonName
).map do |name|
  FederationAttributeAlias.create!(name: name)
end

FederationAttribute.create!(
  oid: 'oid:2.5.4.3',
  internal_alias: 'cn',
  http_header: 'HTTP_CN',
  federation_attribute_aliases: faas,
  primary_alias_id: faas.first.id,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'displayName'
)

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.241',
  internal_alias: 'displayname',
  http_header: 'HTTP_DISPLAYNAME',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonAffiliation'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.1',
  internal_alias: 'unscoped_affiliation',
  http_header: 'HTTP_UNSCOPED_AFFILIATION',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonAssurance'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.11',
  internal_alias: 'assurance',
  http_header: 'HTTP_ASSURANCE',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonEntitlement'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.7',
  internal_alias: 'entitlement',
  http_header: 'HTTP_ENTITLEMENT',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonScopedAffiliation'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.9',
  internal_alias: 'affiliation',
  http_header: 'HTTP_AFFILIATION',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonTargetedID'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.10',
  internal_alias: 'target_id',
  http_header: 'HTTP_TARGETED_ID',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faas = %w(
  mail
  email
).map do |name|
  FederationAttributeAlias.create!(
    name: name
  )
end

FederationAttribute.create!(
  oid: 'oid:0.9.2342.19200300.100.1.3',
  internal_alias: 'mail',
  http_header: 'HTTP_MAIL',
  federation_attribute_aliases: faas,
  primary_alias_id: faas.first.id,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

faas = %w(
  o
  organizationName
).map do |name|
  FederationAttributeAlias.create!(
    name: name
  )
end

FederationAttribute.create!(
  oid: 'oid:2.5.4.10',
  internal_alias: 'o',
  http_header: 'HTTP_O',
  federation_attribute_aliases: faas,
  primary_alias_id: faas.first.id,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

# Optional

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_BUSINESSCATEGORY',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'businessCategory'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_DEPARTMENTNUMBER',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'departmentNumber'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_DIVISION',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'division'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_EDUPERSONORCID',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'eduPersonOrcid'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

faa = FederationAttributeAlias.create!(
  name: 'givenName'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.42',
  internal_alias: 'givenname',
  http_header: 'HTTP_GIVENNAME',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'mobileNumber'
)

FederationAttribute.create!(
  oid: 'oid:0.9.2342.19200300.100.1.41',
  internal_alias: 'mobilenumber',
  http_header: 'HTTP_MOBILENUMBER',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]

)

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_ORGANIZATIONALUNIT',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'organizationalUnit'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

faa = FederationAttributeAlias.create!(
  name: 'postalAddress'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.16',
  internal_alias: 'postaladdress',
  http_header: 'HTTP_POSTALADDRESS',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_HOMEORGANIZATION',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'schacHomeOrganization'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

# FederationAttribute.create!(
#   oid: nil,
#   http_header: 'HTTP_HOMEORGANIZATIONTYPE',
#   federation_attribute_aliases: [
#     FederationAttributeAlias.new(
#       name: 'schacHomeOrganizationType'
#     )
#   ],
#   category_attributes: [
#     CategoryAttribute.new(presence: false, category: optional)
#   ]
# )

faas = %w(
  surname
  sn
).map do |name|
  FederationAttributeAlias.create!(name: name)
end

FederationAttribute.create!(
  oid: 'oid:2.5.4.4',
  internal_alias: 'sn',
  http_header: 'HTTP_SN',
  federation_attribute_aliases: faas,
  primary_alias_id: faas.first.id,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'telephoneNumber'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.20',
  internal_alias: 'telephonenumber',
  http_header: 'HTTP_TELEPHONENUMBER',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonPrincipalName'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.6',
  internal_alias: 'eppn',
  http_header: 'HTTP_EPPN',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)
