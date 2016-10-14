# frozen_string_literal: true
class Snapshot < ApplicationRecord
  has_many :snapshot_attribute_values
  has_many :attribute_values, through: :snapshot_attribute_values
  belongs_to :subject

  valhammer

  def name(explicit_subject = nil)
    explicit_subject ||= subject

    "Snapshot #{number(explicit_subject)}"
  end

  def taken_at
    created_at.to_formatted_s(:rfc822)
  end

  def latest?(subject)
    Snapshot.latest(subject) == self
  def number(explicit_subject = nil)
    explicit_subject ||= subject

    Snapshot.where(subject: explicit_subject).ids.index(id) + 1
  end

  end

  class << self
    def latest(subject)
      subject.snapshots.last
    end

    def create_from_receiver(subject, attrs)
      snapshot = Snapshot.new
      subject.snapshots << snapshot

      assign_attributes(attrs, snapshot)
    end

    def assign_attributes(attrs, snapshot)
      FederationAttribute.where(http_header: attrs.keys).find_each do |db_attr|
        parse_attribute_values(db_attr, attrs).each do |value|
          next if value.blank?

          snapshot.attribute_values << AttributeValue.create!(
            value: value,
            federation_attribute: db_attr
          )
        end
      end

      snapshot
    end

    def parse_attribute_values(db_attribute, attrs)
      if db_attribute.singular?
        [attrs[db_attribute.http_header]]
      else
        Class.new.extend(ShibRack::AttributeMapping::ClassMethods)
             .parse_multi_value(attrs[db_attribute.http_header])
      end
    end
  end

  # :nocov:
  rails_admin do
    list do
      field :id do
        label label.upcase
      end

      field :subject do
        searchable [:name]
        queryable true
      end
    end

    field :subject
    field :attribute_values do
      label label.titleize
    end

    show do
      field :created_at
      field :updated_at

      fields :created_at, :updated_at do
        label label.titleize
      end
    end
  end
  # :nocov:
end
