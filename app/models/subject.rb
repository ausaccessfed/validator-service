# frozen_string_literal: true
class Subject < ActiveRecord::Base
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

  class << self
    def create_from_receiver(attrs)
      identifier = attrs['HTTP_TARGETED_ID']

      subject = Subject.find_or_initialize_by(targeted_id: identifier) do |s|
        s.enabled = true
        s.complete = true
      end

      subject.update!(name: best_guess_name(attrs), mail: attrs['HTTP_MAIL'])

      subject
    end

    def best_guess_name(attrs)
      attrs['HTTP_DISPLAYNAME'] ||
        attrs['HTTP_CN'] ||
        attrs['HTTP_PRINCIPALNAME']
    end
  end
end
