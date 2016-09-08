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
    FactoryGirl.create(:federation_attribute,
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
      auedupersonsharedtoken: 'oid:1.3.6.1.4.1.27856.1.2.5',
      commonname: 'oid:2.5.4.3',
      displayname: 'oid:2.16.840.1.113730.3.1.241',
      edupersonaffiliation: 'oid:1.3.6.1.4.1.5923.1.1.1.1',
      edupersonassurance: 'oid:1.3.6.1.4.1.5923.1.1.1.11',
      edupersonentitlement: 'oid:1.3.6.1.4.1.5923.1.1.1.7',
      edupersonscopedaffiliation: 'oid:1.3.6.1.4.1.5923.1.1.1.9',
      givenname: 'oid:2.5.4.42',
      mail: 'oid:0.9.2342.19200300.100.1.3',
      mobilenumber: 'oid:0.9.2342.19200300.100.1.41',
      o: 'oid:2.5.4.10',
      postaladdress: 'oid:2.5.4.16',
      principalname: 'oid:1.3.6.1.4.1.5923.1.1.1.6',
      surname: 'oid:2.5.4.4',
      targeted_id: 'oid:1.3.6.1.4.1.5923.1.1.1.10',
      telephonenumber: 'oid:2.5.4.20'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
