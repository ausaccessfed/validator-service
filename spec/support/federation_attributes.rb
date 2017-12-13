# frozen_string_literal: true

module FederationAttributes
  def create_federation_attributes(attributes = nil)
    attributes ||= oids.keys

    attributes = attributes.map do |name|
      [name, "HTTP_#{name.upcase}"]
    end

    attributes.map do |name, http_header|
      faa = FederationAttributeAlias.create!(name: name)

      create_federation_attribute(name, http_header, faa)
    end
  end

  def create_federation_attribute(name, http_header, faa)
    FactoryBot.create(:federation_attribute,
                       http_header: http_header,
                       internal_alias: name,
                       oid: oids[name],
                       federation_attribute_aliases: [faa],
                       primary_alias: faa)
  end

  private

  # rubocop:disable Metrics/MethodLength
  def oids
    {
      persistent_id: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent',
      auedupersonsharedtoken: 'oid:1.3.6.1.4.1.27856.1.2.5',
      cn: 'oid:2.5.4.3',
      displayname: 'oid:2.16.840.1.113730.3.1.241',
      eppn: 'oid:1.3.6.1.4.1.5923.1.1.1.6',
      unscoped_affiliation: 'oid:1.3.6.1.4.1.5923.1.1.1.1',
      assurance: 'oid:1.3.6.1.4.1.5923.1.1.1.11',
      entitlement: 'oid:1.3.6.1.4.1.5923.1.1.1.7',
      scoped_affiliation: 'oid:1.3.6.1.4.1.5923.1.1.1.9',
      givenname: 'oid:2.5.4.42',
      mail: 'oid:0.9.2342.19200300.100.1.3',
      mobilenumber: 'oid:0.9.2342.19200300.100.1.41',
      o: 'oid:2.5.4.10',
      postaladdress: 'oid:2.5.4.16',
      sn: 'oid:2.5.4.4',
      targeted_id: 'oid:1.3.6.1.4.1.5923.1.1.1.10',
      telephonenumber: 'oid:2.5.4.20'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
