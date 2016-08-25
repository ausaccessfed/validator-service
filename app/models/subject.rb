# frozen_string_literal: true
class Subject < ApplicationRecord
  include Accession::Principal

  has_many :subject_roles
  has_many :roles, through: :subject_roles

  has_many :snapshots

  valhammer

  scope :from_attributes, lambda { |attributes|
    where(targeted_id: attributes['HTTP_TARGETED_ID'])
      .or(
        where(auedupersonsharedtoken:
          attributes['HTTP_AUEDUPERSONSHAREDTOKEN'])
      ).order(created_at: :asc)
  }

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
    Subject.from_attributes(
      'HTTP_TARGETED_ID' => targeted_id,
      'HTTP_AUEDUPERSONSHAREDTOKEN' => auedupersonsharedtoken
    ).count == 1
  end

  class << self
    def create_from_receiver(attrs)
      subject = Subject.most_recent(attrs)

      unless subject
        subject = Subject.new
        subject.enabled = true
        subject.complete = true
      end

      subject.name = best_guess_name(attrs)
      subject.mail = attrs['HTTP_MAIL']
      subject.targeted_id = attrs['HTTP_TARGETED_ID']
      subject.auedupersonsharedtoken = attrs['HTTP_AUEDUPERSONSHAREDTOKEN']

      subject.save!

      subject
    end

    def most_recent(attrs)
      Subject.from_attributes(attrs).last
    end

    def best_guess_name(attrs)
      attrs['HTTP_DISPLAYNAME'] ||
        attrs['HTTP_CN'] ||
        combined_name
    end

    def combined_name(attrs)
      "#{attrs['HTTP_GIVENNAME']} #{attrs['HTTP_SURNAME']}".strip
    end
  end
end
