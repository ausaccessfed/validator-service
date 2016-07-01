# frozen_string_literal: true
class Snapshot < ActiveRecord::Base
  has_many :snapshot_attribute_values
  has_many :attribute_values, through: :snapshot_attribute_values
  belongs_to :subject

  valhammer

  class << self
    def create_from_receiver(subject, attrs)
      snapshot = Snapshot.new
      subject.snapshots << snapshot

      attributes = FederationAttribute.where(http_header: attrs.keys)

      attributes.each do |attribute|
        values = if attribute.singular?
                   [attrs[attribute.http_header]]
                 else
                   attrs[attribute.http_header].split(';')
        end

        values.each do |value|
          snapshot.attribute_values << AttributeValue.create!(
            value: value,
            federation_attribute: attribute
          )
        end
      end

      snapshot
    end
  end
end
