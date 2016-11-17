# frozen_string_literal: true
class Subject < ApplicationRecord
  include Accession::Principal
  include SubjectAdmin

  has_many :subject_roles
  has_many :roles, through: :subject_roles

  has_many :snapshots

  valhammer

  def permissions
    roles.includes(:permissions).flat_map do |role|
      role.permissions.map(&:value)
    end
  end

  def functioning?
    enabled?
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
    n = FederationAttribute.find_by(internal_alias: :displayname).http_header
    self.name = attrs[n] ||= 'Unknown Subject'

    self.mail = attrs[
      FederationAttribute.find_by(internal_alias: :mail).http_header
    ]

    pid = FederationAttribute.find_by(internal_alias: :persistent_id)
    tid = FederationAttribute.find_by(internal_alias: :targeted_id)
    self.federated_id = attrs[pid.http_header] ||= attrs[tid.http_header]
  end

  def shared_token
    snapshots.last.attribute_values.find_by(
      federation_attribute_id:
        FederationAttribute.find_by(internal_alias: :auedupersonsharedtoken).id
    ).try(:value)
  end

  class << self
    def find_from_attributes(attrs)
      pid = FederationAttribute.find_by(internal_alias: :persistent_id)
      tid = FederationAttribute.find_by(internal_alias: :targeted_id)
      Subject.find_by(
        federated_id: attrs[pid.http_header] ||= attrs[tid.http_header]
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
  end
end
