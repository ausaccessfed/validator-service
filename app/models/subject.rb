# frozen_string_literal: true
class Subject < ApplicationRecord
  include Accession::Principal

  has_many :subject_roles
  has_many :roles, through: :subject_roles

  has_many :snapshots

  valhammer

  def permissions
    roles.flat_map { |role| role.permissions.map(&:value) }
  end

  def functioning?
    enabled?
  end

  def entitlements=(values)
    assigned = values.map do |value|
      Role.for_entitlement(value).tap do |r|
        roles << r unless roles.include?(r)
      end
    end

    subject_roles.where.not(role: assigned).destroy_all
  end

  def valid_identifier_history?
    Subject.where(targeted_id: targeted_id).count == 1
  end

  def subject_attributes(attrs)
    self.name = Subject.best_guess_name(attrs)
    self.mail = attrs[FederationAttribute.internal_aliases[:mail].http_header]
    self.targeted_id = attrs[
      FederationAttribute.internal_aliases[:targeted_id].http_header
    ]
  end

  def admin?
    roles.any?(&:admin_entitlements?)
  end

  def shared_token
    snapshots.last.attribute_values.find_by(
      federation_attribute_id:
        FederationAttribute.internal_aliases[:auedupersonsharedtoken].id
    ).try(:value)
  end

  class << self
    def create_from_receiver(attrs)
      subject = Subject.most_recent(attrs)

      unless subject
        subject = Subject.new
        subject.enabled = true
        subject.complete = true
      end

      subject.subject_attributes(attrs)
      subject.save!

      subject
    end

    def best_guess_name(attrs)
      attrs[FederationAttribute.internal_aliases[:displayname].http_header] ||
        attrs[FederationAttribute.internal_aliases[:cn].http_header] ||
        combined_name
    end

    def combined_name(attrs)
      "#{attrs[FederationAttribute.internal_aliases[:givenname].http_header]} "\
      "#{attrs[FederationAttribute.internal_aliases[:surname].http_header]}"
        .strip
    end
  end

  # :nocov:
  rails_admin do
    list do
      field :name

      field :targeted_id do
        label 'Targeted ID'
      end
    end

    field :name
    field :mail
    field :enabled
    field :complete

    field :targeted_id do
      label 'Targeted ID'
    end

    show do
      field :snapshots

      field :created_at
      field :updated_at

      fields :created_at, :updated_at do
        label label.titleize
      end
    end
  end
  # :nocov:
end
