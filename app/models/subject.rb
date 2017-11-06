# frozen_string_literal: true

class Subject < ApplicationRecord
  include Accession::Principal
  include SubjectAdmin

  has_many :subject_roles, dependent: :destroy
  has_many :roles, through: :subject_roles, dependent: :destroy

  has_many :snapshots, dependent: :destroy

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
    identifier_history.compact.uniq(&:value).size == 1
  end

  def subject_attributes(attrs)
    self.name = subject_name(attrs)
    self.mail = subject_mail(attrs)
    self.persistent_id = Subject.extract_persistent_id(attrs)
  end

  def shared_token
    fst = FederationAttribute.find_by(internal_alias: :auedupersonsharedtoken)
    return nil unless fst

    lastest_snapshot_values = snapshots.last.attribute_values
    sst = lastest_snapshot_values.find_by(federation_attribute_id: fst.id)
    sst.try(:value)
  end

  private

  def identifier_history
    fst = FederationAttribute.find_by(internal_alias: :auedupersonsharedtoken)
    return nil unless fst

    snapshots.map do |snapshot|
      snapshot.attribute_values.find_by(federation_attribute_id: fst.id)
    end
  end

  def subject_name(attrs)
    dn = FederationAttribute.find_by(internal_alias: :displayname).http_header
    cn = FederationAttribute.find_by(internal_alias: :cn).http_header

    return 'Unknown Subject' if attrs[dn].blank? && attrs[cn].blank?

    attrs[dn].blank? ? attrs[cn] : attrs[dn]
  end

  def subject_mail(attrs)
    fm = FederationAttribute.find_by(internal_alias: :mail)
    return nil if fm.blank?

    attrs[fm.http_header]
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
