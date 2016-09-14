# frozen_string_literal: true

admin_role = Role.create!(name: 'AAF Admin',
                          entitlement:
                            'urn:mace:aaf.edu.au:ide:internal:aaf-admin')

Permission.create!(role: admin_role,
                   value: 'app:validator:admin:*')

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
  regexp:
    '\A[\w\-]{27}\z',
  regexp_triggers_failure: true,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ],
  description: 'A unique identifier enabling federation spanning services such
 as Grid and Repositories. Values of the identifier are generated using a set
 formula. The value has the following qualities:

<ul>
  <li>unique</li>
  <li>opaque</li>
  <li>non-targeted</li>
  <li>persistent</li>
  <li>resolvable (only by an IdP that has supplied it)</li>
  <li>not re-assignable</li>
  <li>not mutable (refreshing the value is equivalent to creating a new
 identity)</li>
  <li>permitted to be displayed
    <ul>
      <li>(Note: the value is somewhat display friendly, and may be appended
 to the displayName with a separating space, and used as a unique display name
 to be included in PKI Certificate DNs and as a resource ownership label,
 e.g. John Citizen ZsiAvfxa0BXULgcz7QXknbGtfxk)</li>
    </ul>
  </li>
  <li>portable</li>
</ul>',
  notes_on_format: '27 character PEM "Base 64 Encoding with URL and Filename
 Safe Alphabet" encoded string from a 160-bit SHA1 hash of a globally unique
 string. Padding character, \'=\', is removed from the value. Reference:
 <a href="http://tools.ietf.org/html/rfc4648#page-7" target="_blank">
http://tools.ietf.org/html/rfc4648#page-7</a>',
  notes_on_usage: 'Service providers participating in federation spanning
 services may use auEduPersonSharedToken to uniquely identify users to other
 systems or to map to and from identities in PKI certificates used in grid
 authentication. Other attributes (e.g. displayName, identity provider Id, etc)
 may be used together with auEduPersonSharedToken as a transparent description
 of a particular person at a point in time. This can be implemented to enable
 interoperability of both SAML and PKI based systems with services such as data
 and compute grids. The user’s displayName and identity provider may change over
 time, but it is possible to implement mechanisms for the auEduPersonSharedToken
 to remain the same.',
  notes_on_privacy: 'auEduPersonSharedToken is not a privacy preserving
 identifier and should not be used where services are intended to be provided
 anonymously. Although auEduPersonSharedToken is an opaque value, as it may be
 released with the displayName it cannot be relied upon to preserve anonymity.'
)

faa = FederationAttributeAlias.create!(
  name: 'authenticationMethod'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.9967.1.6.1.2',
  internal_alias: 'authenticationmethod',
  http_header: 'HTTP_AUTHENTICATIONMETHOD',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ],
  description: 'Defines the method(s) used to verify the person\'s identity.',
  notes_on_format: 'A valid URI according to RFC 3986.
<br /><br />
e.g. urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport',
  notes_on_usage: 'The authoritative definition for this attribute can be found
 <a href="http://docs.oasis-open.org/security/saml/v2.0/saml-authn-context-2.0
-os.pdf" target="_blank">here</a> in the SAML 2 specification.'
)

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
  ],
  description: 'An individual\'s common name. For the AAF this is defined as
 the users first name followed by their surname.',
  notes_on_format: 'first name &lt;space&gt; surname',
  notes_on_usage: 'cn can be used by services for searching for a person, or
 creating user friendly auxiliary usernames. Usually the cn will contain two
 names, the first name and surname, with a single space separating them.
 However, in the situation where a user only possesses one name, then the name
 will be consider the users surname.',
  notes_on_privacy: 'This attribute should not be used in transactions where
 it is desirable to maintain user anonymity.'
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
  ],
  description: 'The preferred name of a person to be used when displaying
 entries.',
  notes_on_format: 'free string',
  notes_on_usage: 'Where a relying party has a requirement for a user’s name,
 the displayName is the preferred attribute to request. An identity provider may
 source the value to return as displayName from any appropriate internal
 attributes. Relying parties should note this value is not guaranteed to be
 either unique or persistent. It is not recommended to be used as a unique key
 or for authorisation.',
  notes_on_privacy: 'This attribute should not be used in transactions where
 it is desirable to maintain user anonymity.'
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
  regexp: '\A(faculty|student|staff|employee|member|affiliate' \
          '|alum|library-walk-in)\z',
  regexp_triggers_failure: true,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ],
  description: 'Specifies the person\'s relationship(s) to the institution in
 broad categories.',
  notes_on_format: 'Only these values are allowed:<br /><br />
<blockquote>
  <table class="table table-bordered table-condensed">
    <thead>
      <tr>
        <td><b>Value<span></td>
        <td><b>Meaning</b></td>
      </tr>
    </thead>
    <tbody>
     <tr>
        <td>faculty</td>
        <td>Academic or research staff</td>
      </tr>
      <tr>
        <td>student</td>
        <td>Undergraduate or postgraduate student</td>
      </tr>
      <tr>
        <td>staff</td>
        <td>All staff</td>
      </tr>
      <tr>
        <td>employee</td>
        <td>Employee other than staff, e.g. contractor</td>
      </tr>
      <tr>
        <td>member</td>
        <td>Comprises all the categories named above, plus other members with
 normal institutional privileges, such as honorary staff or visiting scholar
        </td>
      </tr>
      <tr>
        <td>affiliate</td>
        <td>Relationship with the institution short of full member</td>
      </tr>
      <tr>
        <td>alum</td>
        <td>Alumnus/alumna (graduate)</td>
      </tr>
      <tr>
        <td>library-walk-in</td>
        <td>A person physically present in the library</td>
      </tr>
    </tbody>
  </table>
</blockquote>',
  notes_on_usage: 'This attribute, like eduPersonScopedAffiliation, enables an
 organisation to assert its relationship with the user. This addresses the
 common
 case where a resource is provided on a site licence basis, and the only access
 requirement is that the user is a bona fide member of the organisation, or a
 specific school or faculty within it. If there is a value in
 eduPersonPrimaryAffiliation, that value should be stored here as well. This
 attribute may appear suitable for controlling access to, for example, an
 academic licensed commercial software package. However, this is usually not the
 case; such licenses have greater constraints than just
 eduPersonAffiliation=faculty. In most cases an academic user must also agree
 to use the application for only academic purposes and perhaps accept
 obligations such as acknowledging the owners or reporting results in a
 particular way.
 <br /><br />
 There is a knowledge base <a href="http://support.aaf.edu.au/entries/21161973-S
cripting-eduPersonAffiliation" target="_blank">article</a> available that
 explains how to write a Shibboleth IdP script to present attribute:',
  notes_on_privacy: 'eduPersonAffiliation should be used when the service
 provider does not need confirmation of the security domain of the user.
 Service providers who do need the security domain information should ask for
 eduPersonScopedAffiliation instead.
<br /><br />
 Several values of eduPersonAffiliation are regarded as being "contained"
 within other values: for example, the student value is contained within member.
 It is recommended that identity providers have the ability either to maintain
 these multiple values for a given individual, or otherwise provide the ability
 to release either value as appropriate for a particular relying party. For
 example, although some relying parties might require the release of the more
 specific student value, a different relying party that only requires the less
 specific member value should only be sent the less specific value. Releasing
 student in this case gives the relying party more information about the user
 than is required, raising privacy and data protection concerns.
<br /><br />
 Despite the recommendation above that identity providers should be
 conservative in what they send, relying parties are recommended to be liberal
 in what they accept. For example, a relying party requiring member affiliation
 should also accept student, staff, etc. as alternatives.'
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
  ],
  description: 'Set of URIs that assert compliance with specific standards for
  identity assurance.
<br /><br />
This attribute represents identity assurance profiles (IAPs), which are the set
 of standards that are met by an identity assertion, based on the identity
 provider\'s identity management processes, the type of authentication
 credential used, the strength of its binding, etc.  For identity assurance,
 this refers to the strength of the processes used to identify the user at
 the time of user registration.  For token and credential management assurance,
 this refers to the strength of the token used and the strength of the processes
 used to manage tokens and credentials.  Those establishing values for this
 attribute should provide documentation explaining the semantics of the values.
<br /><br />
 The driving force behind the definition of this attribute is to enable
 applications to understand the various strengths of different identity
 management systems and authentication events and the processes and procedures
 governing their operation and to be able to assess whether or not a given
 transaction meets the requirements for access.',
  notes_on_format: 'A URN that resolves to the definition of the value used.
<br /><br />
 URNs must have format urn:mace:aaf.edu.au:iap:id:.[level], where level is a
 value from 1 to 2, or urn:mace:aaf.edu.au:iap:authn:[level], where level is a
 value from 0 to 2.
 <br /><br />
 E.g.
 <br /><br />
 urn:mace:aaf.edu.au:iap:id:1
 <br />
 urn:mace:aaf.edu.au:iap:id:2
 <br /><br />
 urn:mace:aaf.edu.au:iap:authn:0
 <br />
 urn:mace:aaf.edu.au:iap:authn:1
 <br />
 urn:mace:aaf.edu.au:iap:authn:2',
  notes_on_usage: 'There are different aspects to the concept of assurance,
 including the strength of assurance in the user’s identity and the strength of
 the method used to authenticate the user. In a SAML federation, it is possible
 to use two attributes to differentiate these concepts. The AuthenticationMethod
 attribute that is part of the SAML transaction can assert the strength of the
 authentication method used in the transaction, and the eduPersonAssurance
 attribute can assert the level of assurance in the user’s identity.
 <br /><br />
 The <a href="http://wiki.aaf.edu.au/tech-info/levels-of-assurance">Levels of
 Assurance</a> section provides a standard vocabulary to express both of these
 concepts – the strength of assurance in the user’s identity and the strength
 of the method used to authenticate the user.',
  notes_on_privacy: 'Because a particular assurance value may be associated
 with a small number of persons at an organisation, it may be prudent to remove
 assurance information from data when performing anonymisation or
 deidentification.'
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
    CategoryAttribute.new(presence: false, category: core)
  ],
  description: 'URI (either URN or URL) that indicates a set of rights to
  specific resources.',
  notes_on_format: '',
  notes_on_usage: 'The meaning of a given value of eduPersonEntitlement is
  normally defined by a service provider. In the case of a value using the
  "http" scheme, it is recommended that the value resolve to a document giving
  the definition of the value. Having defined the meaning of the attribute
  value, the service provider then invites some or all identity providers to
  express that value for those users who satisfy the definition. In this way
  the service provider can delegate to the identity provider some or all of
  the responsibility for authorisation of access to a particular resource.
<br /><br />
 Typically, this attribute is used to assert entitlements over and above those
 enjoyed by other members of the organisation; for example, "Entitled to access
 the restricted material present in the Med123 resource". In this case, the
 service provider trusts the organisation to verify that the user
 satisfies the (arbitrarily complex) authorisation conditions associated with
 the entitlement. This may involve an additional licence clause, where the
 organisation undertakes to assign the eduPersonEntitlement values according
 to agreed criteria. ',
  notes_on_privacy: 'Because a particular value of eduPersonEntitlement often
 represents an entitlement to access a specific resource, Identity Providers
 should be capable of associating any number of entitlements with an individual
 user. However, such entitlements may represent personal or even sensitive
 personal data about the individual. It is therefore important to control the
 release of individual values of eduPersonEntitlement closely, so that only
 Service Providers with a legitimate need for any given value of
 eduPersonEntitlement will have that value released to them. For example,
 values defined by a particular Service Provider should normally only be
 released back to that same Service Provider.'
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
  regexp: '\A(faculty|student|staff|employee|member|affiliate' \
          '|alum|library-walk-in)\z',
  regexp_triggers_failure: true,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ],
  description: 'Specifies the person\'s relationship(s) to the institution in
  broad categories.',
  notes_on_format: 'Only these values are allowed:
  <br /><br />
<blockquote>
  <table class="table table-bordered table-condensed">
    <thead>
      <tr>
        <td><b>Value<span></td>
        <td><b>Meaning</b></td>
      </tr>
    </thead>
    <tbody>
     <tr>
        <td>faculty</td>
        <td>Academic or research staff</td>
      </tr>
      <tr>
        <td>student</td>
        <td>Undergraduate or postgraduate student</td>
      </tr>
      <tr>
        <td>staff</td>
        <td>All staff</td>
      </tr>
      <tr>
        <td>employee</td>
        <td>Employee other than staff, e.g. contractor</td>
      </tr>
      <tr>
        <td>member</td>
        <td>Comprises all the categories named above, plus other members with
 normal institutional privileges, such as honorary staff or visiting scholar
        </td>
      </tr>
      <tr>
        <td>affiliate</td>
        <td>Relationship with the institution short of full member</td>
      </tr>
      <tr>
        <td>alum</td>
        <td>Alumnus/alumna (graduate)</td>
      </tr>
      <tr>
        <td>library-walk-in</td>
        <td>A person physically present in the library</td>
      </tr>
    </tbody>
  </table>
</blockquote>',
  notes_on_usage: 'This attribute, like eduPersonScopedAffiliation, enables an
  organisation to assert its relationship with the user. This addresses the
  common case where a resource is provided on a site licence basis, and the
  only access requirement is that the user is a bona fide member of the
  organisation, or a specific school or faculty within it. If there is a
  value in eduPersonPrimaryAffiliation, that value should be stored here as
  well. This attribute may appear suitable for controlling access to, for
  example, an academic licensed commercial software package. However, this is
  usually not the case; such licenses have greater constraints than just
  eduPersonAffiliation=faculty. In most cases an academic user must also agree
  to use the application for only academic purposes and perhaps accept
  obligations such as acknowledging the owners or reporting results in a
  particular way.
<br /><br />
 There is a knowledge base article available that explains how to write a
 Shibboleth IdP script to present attribute.',
  notes_on_privacy: 'eduPersonAffiliation should be used when the service
 provider does not need confirmation of the security domain of the user. Service
 providers who do need the security domain information should ask for
 eduPersonScopedAffiliation instead.
<br /><br />
Several values of eduPersonAffiliation are regarded as being "contained" within
 other values: for example, the student value is contained within member. It is
 recommended that identity providers have the ability either to maintain these
 multiple values for a given individual, or otherwise provide the ability to
 release either value as appropriate for a particular relying party.
 For example, although some relying parties might require the release of the
 more specific student value, a different relying party that only requires
 the less specific member value should only be sent the less specific value.
 Releasing student in this case gives the relying party more information about
 the user than is required, raising privacy and data protection concerns.
<br /><br />
Despite the recommendation above that identity providers should be conservative
 in what they send, relying parties are recommended to be liberal in what they
 accept. For example, a relying party requiring member affiliation should also
 accept student, staff, etc. as alternatives.'
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonTargetedID'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.10',
  internal_alias: 'targeted_id',
  http_header: 'HTTP_TARGETED_ID',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  regexp:
    '\A(?=[\S]{0,256}$)[^!]+![^!]+![^!]+\z',
  regexp_triggers_failure: true,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ],
  description: 'A persistent, non-reassigned, privacy-preserving identifier for
  a user shared between an identity provider and service provider. An identity
  provider uses the appropriate value of this attribute when communicating with
  a particular service provider or group of service providers, and does not
  reveal that value to any other service provider except in limited
  circumstances.
<br /><br />
 Persistence: eduPersonTargetedID does not require a specific lifetime, but the
 association should be maintained longer than a single user interaction and long
 enough to be useful as a key for a particular service that is consuming it.
<br /><br />
 Privacy: This attribute is designed to preserve the user\'s privacy and
 inhibit the ability of multiple unrelated services from correlating user
 activity by comparing values. It is therefore required to be opaque.
<br /><br />
 Uniqueness: A value of this attribute is intended only for consumption by a
 specific audience of applications (often a single one). Values of this
 attribute therefore must be unique within the namespace of the identity
 provider and the namespace of the service provider(s) for whom the value
 is created. The value is "qualified" by these two namespaces and need not
 be unique outside them. Logically, the attribute value is made up of the
 triple of an identifier, the identity provider, and the service provider(s).
<br /><br />
 Reassignment: A distinguishing feature of this attribute is that it prohibits
 reassignment. Since the values are opaque, there is no meaning attached to any
 particular value beyond its identification of the user. Therefore particular
 values created by an identity provider must not be  reassigned such that the
 same value given to a particular',
  notes_on_format: 'The eduPersonTargetedID value is an opaque string of no
  more than 256 characters.
<br /><br />
The format comprises the entity name of the identity provider, the entity name
 of the service provider, and the opaque string value. These strings are
 separated by “!” symbols.',
  notes_on_usage: 'If a service provider is presented only with the affiliation
  of an anonymous subject, as provided by eduPersonScopedAffiliation, it cannot
  provide service personalisation or usage monitoring across sessions.
  These capabilities are enabled by the eduPersonTargetedID attribute, which
  provides a persistent user pseudonym, distinct for each service provider.
<br /><br />
A service provider may use eduPersonTargetedID to support aspects of its
 service that depend on recognising the same user from session to session.
 The most common use is to enable service personalisation, to record user
 preferences such as stored search expressions across user sessions. A secondary
 use is to enable tracking of user activity, to make it easier to detect
 systematic downloading of content or other suspected breaches of licence
 conditions.
<br /><br />
 The attribute enables an organisation to provide a persistent, opaque, user
 identifier to a service provider. For each user, the identity provider presents
 a different value of eduPersonTargetedID to each service provider to which the
 attribute is released.
<br /><br />
The eduPerson specification requires that a value of eduPersonTargetedID once
 assigned to a user for a given service provider shall never be reassigned to
 another user. Users and service providers should note, however, that not all
 identity providers may be able to guarantee that a  user will always present
 the same value of eduPersonTargetedID; indeed, identity providers may offer
 their users the ability to generate new values of  eduPersonTargetedID if they
 feel their privacy has been compromised. identity providers and users should
 note that changing a user’s eduPersonTargetedID for a particular service
 provider may break the relationship with that service provider.',
  notes_on_privacy: 'eduPersonTargetedID is intended to be a privacy-preserving
   attribute.'
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
  regexp: '\A\S+@\S+\z',
  regexp_triggers_failure: true,
  category_attributes: [
    CategoryAttribute.new(presence: true, category: core)
  ],
  description: 'The person\'s public email address used to contact the person
  regarding matters related to their organisation.',
  notes_on_format: 'A valid email address as defined in RFC 822.',
  notes_on_usage: 'Mail address should only be used when the service provider
  needs to communicate with the end user. It should not be used as an
  identifier and should not be relied upon to be persistent.',
  notes_on_privacy: 'This attribute should not be used in transactions where
  it is desirable to maintain user anonymity. Privacy considerations should be
  observed when making a decision about releasing this attribute, as it
  provides user contact information.'
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
  ],
  description: 'The standard name of the top-level organization (institution)
  with which this person is associated.',
  notes_on_format: 'free string',
  notes_on_usage: 'This attribute should not be used for authorisation
  decisions.  If service providers wish to make authorisation decisions based
  on a user\'s home organisation, it is recommended that the
  schacHomeOrganization attribute be used for this purpose.',
  notes_on_privacy: ''
)

# Optional

faa = FederationAttributeAlias.create!(
  name: 'auEduPersonLegalName'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.27856.1.2.2',
  internal_alias: 'auedupersonlegalname',
  http_header: 'HTTP_AUEDUPERSONLEGALNAME',
  federation_attribute_aliases: [faa],
  primary_alias_id: faa.id,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'The users legal name, as per their passport, birth certificate,
  or other legal document',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'businessCategory'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.15',
  internal_alias: 'businesscategory',
  http_header: 'HTTP_BUSINESSCATEGORY',
  federation_attribute_aliases: [faa],
  primary_alias_id: faa.id,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Identifies the business in which the organisational unit
  is involved.',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'departmentNumber'
)

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.2',
  internal_alias: 'departmentnumber',
  http_header: 'HTTP_DEPARTMENTNUMBER',
  federation_attribute_aliases: [faa],
  primary_alias_id: faa.id,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Identifies the department for which the person works.',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'division'
)

FederationAttribute.create!(
  oid: 'oid:1.2.840.113556.1.4.261',
  internal_alias: 'division',
  http_header: 'HTTP_DIVISION',
  federation_attribute_aliases: [faa],
  primary_alias_id: faa.id,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Specify a person’s division within their organisation',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonPrimaryAffiliation'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.5',
  internal_alias: 'edupersonprimaryaffiliation',
  http_header: 'HTTP_EDUPERSONPRIMARYAFFILIATION',
  federation_attribute_aliases: [faa],
  primary_alias_id: faa.id,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Specifies the persons PRIMARY relationship to the institution
  in broad categories such as student, faculty, staff, alum, etc.',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
)

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
  ],
  description: 'Person\'s given or first name.',
  notes_on_format: 'Free string',
  notes_on_usage: '',
  notes_on_privacy: ''
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
  ],
  description: 'The public mobile telephone number on which the person may be
  contacted regarding matters related to their organization.',
  notes_on_format: 'Mobile telephone numbers should be specified in
  international format.  No spaces should be used.
  <br /><br />
  e.g. +61412345678',
  notes_on_usage: '',
  notes_on_privacy: ''
)

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
  ],
  description: 'The public postal address associated with the person for
  matters related to their role within their organisation.',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
)

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
  ],
  description: 'The person\'s surname.',
  notes_on_format: 'free string',
  notes_on_usage: '',
  notes_on_privacy: ''
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
  ],
  description: 'The public telephone number on which the person may be
  contacted regarding matters related to their organization.',
  notes_on_format: 'Telephone numbers should be specified in international
  format.  No spaces should be used.
<br /><br />
e.g. +61712345678',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'employeeNumber'
)

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.3',
  internal_alias: 'employeenumber',
  http_header: 'HTTP_EMPLOYEENUMBER',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Numerically identifies an employee within an organization',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
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
  ],
  description: 'eduPerson per Internet2 and EDUCAUSE.',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faas = %w(
  homeOrganization
  schacHomeOrganization
).map do |name|
  FederationAttributeAlias.create!(
    name: name
  )
end

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.25178.1.2.9',
  internal_alias: 'homeorganization',
  http_header: 'HTTP_HOMEORGANIZATION',
  federation_attribute_aliases: faas,
  primary_alias: faas.first,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Users Home Organization.',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faas = %w(
  homeOrganizationType
  schacHomeOrganizationType
).map do |name|
  FederationAttributeAlias.create!(
    name: name
  )
end

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.25178.1.2.10',
  internal_alias: 'homeorganizationtype',
  http_header: 'HTTP_HOMEORGANIZATIONTYPE',
  federation_attribute_aliases: faas,
  primary_alias: faas.first,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Type of Organization the user belongs too.',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faas = %w(
  organizationalUnit
  ou
).map do |name|
  FederationAttributeAlias.create!(
    name: name
  )
end

FederationAttribute.create!(
  oid: 'oid:2.5.4.11',
  internal_alias: 'organizationalunit',
  http_header: 'HTTP_ORGANIZATIONALUNIT',
  federation_attribute_aliases: faas,
  primary_alias: faas.first,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'OrganizationalUnit currently used for faculty membership of
  staff',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'schacPersonalUniqueID'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.25178.1.2.15',
  internal_alias: 'schacpersonaluniqueid',
  http_header: 'HTTP_SCHACPERSONALUNIQUEID',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'Specifies a "legal unique identifier" for the subject
  it is associated with.',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'uid'
)

FederationAttribute.create!(
  oid: 'oid:0.9.2342.19200300.100.1.1',
  internal_alias: 'uid',
  http_header: 'HTTP_UID',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: 'The users central LDAP directory username.',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'title'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.12',
  internal_alias: 'title',
  http_header: 'HTTP_TITLE',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'description'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.13',
  internal_alias: 'description',
  http_header: 'HTTP_DESCRIPTION',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'initials'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.43',
  internal_alias: 'initials',
  http_header: 'HTTP_INITIALS',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'employeeType'
)

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.4',
  internal_alias: 'employeetype',
  http_header: 'HTTP_EMPLOYEETYPE',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'carLicense'
)

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.1',
  internal_alias: 'carlicense',
  http_header: 'HTTP_CARLICENSE',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'preferredLanguage'
)

FederationAttribute.create!(
  oid: 'oid:2.16.840.1.113730.3.1.39',
  internal_alias: 'preferredlanguage',
  http_header: 'HTTP_PREFERREDLANGUAGE',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'manager'
)

FederationAttribute.create!(
  oid: 'oid:0.9.2342.19200300.100.1.10',
  internal_alias: 'manager',
  http_header: 'HTTP_MANAGER',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'seeAlso'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.34',
  internal_alias: 'seealso',
  http_header: 'HTTP_SEEALSO',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'facsimileTelephoneNumber'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.23',
  internal_alias: 'facsimiletelephonenumber',
  http_header: 'HTTP_FACSIMILETELEPHONENUMBER',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'street'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.9',
  internal_alias: 'street',
  http_header: 'HTTP_STREET',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'postOfficeBox'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.18',
  internal_alias: 'postofficebox',
  http_header: 'HTTP_POSTOFFICEBOX',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'postalCode'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.17',
  internal_alias: 'postalcode',
  http_header: 'HTTP_POSTALCODE',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'st'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.8',
  internal_alias: 'st',
  http_header: 'HTTP_ST',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'l'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.7',
  internal_alias: 'l',
  http_header: 'HTTP_L',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'physicalDeliveryOfficeName'
)

FederationAttribute.create!(
  oid: 'oid:2.5.4.19',
  internal_alias: 'physicaldeliveryofficename',
  http_header: 'HTTP_PHYSICALDELIVERYOFFICENAME',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)

faa = FederationAttributeAlias.create!(
  name: 'eduPersonOrcid'
)

FederationAttribute.create!(
  oid: 'oid:1.3.6.1.4.1.5923.1.1.1.16',
  internal_alias: 'edupersonorcid',
  http_header: 'HTTP_EDUPERSONORCID',
  federation_attribute_aliases: [faa],
  primary_alias: faa,
  regexp:
    '\A(http(|s):\/\/orcid.org\/)[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9X]{4}\z',
  regexp_triggers_failure: true,
  category_attributes: [
    CategoryAttribute.new(presence: false, category: optional)
  ],
  description: '',
  notes_on_format: '',
  notes_on_usage: '',
  notes_on_privacy: ''
)
