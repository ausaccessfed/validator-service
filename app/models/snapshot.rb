# frozen_string_literal: true

class Snapshot < ApplicationRecord
  has_many :snapshot_attribute_values
  has_many :attribute_values, through: :snapshot_attribute_values
  belongs_to :subject

  valhammer

  scope :provisioned, lambda {
    includes(snapshot_attribute_values: [:attribute_value])
  }

  def name(explicit_subject = nil)
    explicit_subject ||= subject

    "Snapshot #{number(explicit_subject)}"
  end

  def number(explicit_subject = nil)
    explicit_subject ||= subject

    Snapshot.where(subject: explicit_subject).ids.index(id) + 1
  end

  def latest?(explicit_subject = nil)
    explicit_subject ||= subject

    Snapshot.latest(explicit_subject) == self
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
  # rubocop:disable Metrics/BlockLength
  rails_admin do
    list do
      field :id do
        label 'Internal ID'
      end

      field :name

      field :subject do
        searchable [:name]
        queryable true
      end
    end

    edit do
      field :subject

      field :attribute_values do
        label label.titleize
      end
    end

    show do
      field :name
      field :subject

      field :attribute_values do
        label label.titleize
      end

      field :created_at
      field :updated_at

      fields :created_at, :updated_at do
        label label.titleize
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
  # :nocov:
end
