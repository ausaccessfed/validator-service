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
      update_snapshot_attribute_values(
        snapshot,
        attrs.except(:affiliation, :scoped_affiliation)
      )
      update_snapshot_affiliations(snapshot, attrs)
      update_snapshot_scoped_affiliations(snapshot, attrs)
      snapshot
    end

    def update_snapshot_attribute_values(snapshot, attrs)
      attrs.each do |k, v|
        fed_attr = FederationAttribute.find_or_create_by!(name: k)
        snapshot.attribute_values << AttributeValue.create(
          value: v,
          federation_attribute_id: fed_attr.id
        )
      end
    end

    def update_snapshot_affiliations(snapshot, attrs)
      fed_attr = FederationAttribute.find_or_create_by!(
        name: 'affiliation',
        singular: false
      )

      attrs[:affiliation].each do |affiliation|
        snapshot.attribute_values << AttributeValue.create(
          value: affiliation,
          federation_attribute_id: fed_attr.id
        )
      end
    end

    def update_snapshot_scoped_affiliations(snapshot, attrs)
      fed_attr = FederationAttribute.find_or_create_by!(
        name: 'scoped_affiliation',
        singular: false
      )

      attrs[:scoped_affiliation].each do |scoped_affiliation|
        snapshot.attribute_values << AttributeValue.create(
          value: scoped_affiliation,
          federation_attribute_id: fed_attr.id
        )
      end
    end
  end
end
