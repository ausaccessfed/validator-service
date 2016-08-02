# frozen_string_literal: true

FederationAttribute.destroy_all

core = Category.create!(
  name: 'Core Attributes',
  description: 'AAF Core Attributes.',
  enabled: true,
  order: 1
)

optional = Category.create!(
  name: 'Optional Attributes',
  description: 'AAF Optional Attributes.',
  enabled: true,
  order: 2
)

# Core attributes

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.27856.1.2.5',
  http_header: 'HTTP_AUEDUPERSONSHAREDTOKEN',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'auEduPersonSharedToken'
    )
  ],
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

fa = FederationAttribute.create!(
  oid: 'oid:2.5.4.3',
  http_header: 'HTTP_COMMONNAME',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

%w(
  cn
  commonName
).each do |name|
  fa.federation_attribute_aliases << [
    FederationAttributeAlias.new(
      name: name
    )
  ]
end

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.241',
  http_header: 'HTTP_DISPLAYNAME',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'displayName'
    )
  ],
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.1',
  http_header: 'HTTP_EDUPERSONAFFILIATION',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'eduPersonAffiliation'
    )
  ],
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.11',
  http_header: 'HTTP_EDUPERSONASSURANCE',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'eduPersonAssurance'
    )
  ],
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.7',
  http_header: 'HTTP_EDUPERSONENTITLEMENT',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'eduPersonEntitlement'
    )
  ],
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.9',
  http_header: 'HTTP_EDUPERSONSCOPEDAFFILIATION',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'eduPersonScopedAffiliation'
    )
  ],
  singular: false,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.10',
  http_header: 'HTTP_TARGETED_ID',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'eduPersonTargetedID'
    )
  ],
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

fa = FederationAttribute.create!(
  oid: 'oid:0.9.2342.19200300.100.1.3',
  http_header: 'HTTP_MAIL',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

%w(
  mail
  email
).each do |name|
  fa.federation_attribute_aliases << [
    FederationAttributeAlias.new(
      name: name
    )
  ]
end

fa = FederationAttribute.create!(
  oid: 'oid:2.5.4.10',
  http_header: 'HTTP_O',
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ]
)

%w(
  o
  organizationName
).each do |name|
  fa.federation_attribute_aliases << [
    FederationAttributeAlias.new(
      name: name
    )
  ]
end

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

FederationAttribute.create!(
  oid: 'oid:2.5.4.42',
  http_header: 'HTTP_GIVENNAME',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'givenName'
    )
  ],
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create!(
  oid: 'oid:0.9.2342.19200300.100.1.41',
  http_header: 'HTTP_MOBILENUMBER',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'mobileNumber'
    )
  ],
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

FederationAttribute.create!(
  oid: 'oid:2.5.4.16',
  http_header: 'HTTP_POSTALADDRESS',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'postalAddress'
    )
  ],
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

fa = FederationAttribute.create!(
  oid: 'oid:2.5.4.4',
  http_header: 'HTTP_SURNAME',
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

%w(
  surname
  sn
).each do |name|
  fa.federation_attribute_aliases << [
    FederationAttributeAlias.new(
      name: name
    )
  ]
end

FederationAttribute.create!(
  oid: 'oid:2.5.4.20',
  http_header: 'HTTP_TELEPHONENUMBER',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'telephoneNumber'
    )
  ],
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.6',
  http_header: 'HTTP_PRINCIPALNAME',
  federation_attribute_aliases: [
    FederationAttributeAlias.new(
      name: 'eduPersonPrincipalName'
    )
  ],
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ]
)
