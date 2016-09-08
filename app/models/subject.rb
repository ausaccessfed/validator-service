# frozen_string_literal: true
class Subject < ApplicationRecord
  include Accession::Principal
  include SubjectAdmin

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
    snapshots.map do |snapshot|
      snapshot.attribute_values
              .find_by(
                federation_attribute_id:
                FederationAttribute.find_by(
                  internal_alias: :auedupersonsharedtoken
                ).id
              )
    end.compact.uniq(&:value).size == 1
  end

  def subject_attributes(attrs)
    self.name = Subject.best_guess_name(attrs)
    self.mail = attrs[
      FederationAttribute.find_by(internal_alias: :mail).http_header
    ]
    self.targeted_id = attrs[
      FederationAttribute.find_by(internal_alias: :targeted_id).http_header
    ]
  end

  def admin?
    roles.any?(&:admin_entitlements?)
  end

  def shared_token
    snapshots.last.attribute_values.find_by(
      federation_attribute_id:
        FederationAttribute.find_by(internal_alias: :auedupersonsharedtoken).id
    ).try(:value)
  end

  class << self
    def find_from_attributes(attrs)
      Subject.find_by(
        targeted_id: attrs[
          FederationAttribute.find_by(internal_alias: :targeted_id).http_header
        ]
      )
    end

    def create_from_receiver(attrs)
      subject = find_from_attributes(attrs)

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
      attrs[
        FederationAttribute.find_by(internal_alias: :displayname).http_header
      ] || attrs[
        FederationAttribute.find_by(internal_alias: :cn).http_header
      ] || combined_name
    end

    def combined_name(attrs)
      "#{attrs[
        FederationAttribute.find_by(internal_alias: :givenname).http_header
      ]} #{attrs[
        FederationAttribute.find_by(internal_alias: :sn).http_header
      ]}".strip
    end
  end
end
