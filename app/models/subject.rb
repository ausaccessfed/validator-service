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
      r = Role.find_by(entitlement: value)
      roles << r unless roles.include?(r)
    end.flatten

    subject_roles.where.not(role: assigned).destroy_all
  end

  def valid_identifier_history?
    Subject.from_attributes(
      'HTTP_TARGETED_ID' => targeted_id,
      'HTTP_AUEDUPERSONSHAREDTOKEN' => auedupersonsharedtoken
    ).count == 1
  end

  def subject_attributes(attrs)
    self.name = Subject.best_guess_name(attrs)
    self.mail = attrs['HTTP_MAIL']
    self.targeted_id = attrs['HTTP_TARGETED_ID']
    self.auedupersonsharedtoken = attrs['HTTP_AUEDUPERSONSHAREDTOKEN']
  end

  def admin?
    permissions.any? do |permission|
      permission.starts_with?('app:validator:admin:')
    end
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

  # :nocov:
  rails_admin do
    list do
      field :name

      field :targeted_id do
        label 'Targeted ID'
      end

      field :auedupersonsharedtoken do
        label 'Shared Token'
      end
    end

    field :name
    field :mail
    field :enabled
    field :complete

    field :targeted_id do
      label 'Targeted ID'
    end

    field :auedupersonsharedtoken do
      label 'Shared Token'
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
