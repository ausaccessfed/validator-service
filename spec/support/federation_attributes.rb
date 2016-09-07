# frozen_string_literal: true
module FederationAttributes
  def create_federation_attributes(attributes = nil)
    attributes ||= FederationAttribute.oids.keys

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
                       oid: FederationAttribute.oids[name],
                       federation_attribute_aliases: [faa],
                       primary_alias: faa)
  end
end
