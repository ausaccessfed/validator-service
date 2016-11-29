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
    self.name = subject_name(attrs)
    self.mail = subject_mail(attrs)
    self.persistent_id = Subject.extract_persistent_id(attrs)
  end

  def subject_name(attrs)
    fn = FederationAttribute.find_by(internal_alias: :displayname)
    return 'Unknown Subject' unless fn.present?

    attrs[fn.http_header]
  end

  def subject_mail(attrs)
    fm = FederationAttribute.find_by(internal_alias: :mail)
    return nil unless fm.present?

    attrs[fm.http_header]
  end

  def shared_token
    snapshots.last.attribute_values.find_by(
      federation_attribute_id:
        FederationAttribute.find_by(internal_alias: :auedupersonsharedtoken).id
    ).try(:value)
  end

  class << self
    def extract_persistent_id(attrs)
      pid = FederationAttribute.find_by(internal_alias: :persistent_id)
      tid = FederationAttribute.find_by(internal_alias: :targeted_id)
      return attrs[pid.http_header] if pid && attrs[pid.http_header].present?

      attrs[tid.http_header]
    end

    def find_from_attributes(attrs)
      Subject.find_by(persistent_id: extract_persistent_id(attrs))
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
