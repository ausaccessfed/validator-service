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

  class << self
    def create_from_receiver(attrs)
      subject = subject_scope(attrs).find_or_initialize_by({}) do |s|
        s.enabled = true
        s.complete = true
      end

      subject.update!(name: best_guess_name(attrs),
                      mail: attrs['HTTP_MAIL'],
                      targeted_id: attrs['HTTP_TARGETED_ID'],
                      auedupersonsharedtoken:
                      attrs['HTTP_AUEDUPERSONSHAREDTOKEN'])

      subject
    end

    def best_guess_name(attrs)
      attrs['HTTP_DISPLAYNAME'] ||
        attrs['HTTP_CN'] ||
        combined_name
    end

    def combined_name(attrs)
      "#{attrs['HTTP_GIVENNAME']} #{attrs['HTTP_SURNAME']}".strip
    end

    def subject_scope(attrs)
      Subject.where(targeted_id: attrs['HTTP_TARGETED_ID'])
             .or(
               where(auedupersonsharedtoken:
                 attrs['HTTP_AUEDUPERSONSHAREDTOKEN'])
             )
    end

    def check_subject(subject, attrs)
      require_subject_match(subject, attrs, 'HTTP_TARGETED_ID')
      require_subject_match(subject, attrs, 'HTTP_AUEDUPERSONSHAREDTOKEN')
    end

    def require_subject_match(subject, attrs, key)
      incoming = attrs[key]
      existing = subject.send(key.sub(/^HTTP_/, '').downcase)

      return if existing == incoming

      raise("Incoming #{key} `#{incoming}` did not match"\
            " existing `#{existing}`")
    end
  end
end
