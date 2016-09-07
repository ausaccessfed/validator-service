# frozen_string_literal: true
class FederationAttribute < ApplicationRecord
  has_many :category_attributes
  has_many :categories, through: :category_attributes

  has_many :federation_attribute_aliases
  has_many :attribute_values

  belongs_to :primary_alias, class_name: FederationAttributeAlias

  valhammer

  delegate :name, to: :primary_alias, allow_nil: true

  scope :fuzzy_lookup, lambda { |id|
    alias_lookup(id) + where(oid: id)
  }

  scope :alias_lookup, lambda { |id|
    includes(:federation_attribute_aliases)
      .where(federation_attribute_aliases: { name: id })
  }

  def aliases
    federation_attribute_aliases.where
                                .not(federation_attribute_aliases:
                                  { id: primary_alias.id })
  end

  class << self
    def existing_headers
      select(:http_header).map(&:http_header)
    end

    def new_attributes?(keys)
      where(http_header: keys).count != keys.size
    end

    def new_attributes(attrs)
      headers = existing_headers

      attrs.keep_if { |k, _v| !headers.include?(k) }
    end

    def existing_attributes(attrs)
      headers = existing_headers

      attrs.keep_if { |k, _v| headers.include?(k) }
    end

    def oids
      {
        targeted_id: 'oid:1.3.6.1.4.1.5923.1.1.1.10',
        auedupersonsharedtoken: 'oid:1.3.6.1.4.1.27856.1.2.5',
        mail: 'oid:0.9.2342.19200300.100.1.3',
        displayname: 'oid:2.16.840.1.113730.3.1.241',
        cn: 'oid:2.5.4.3',
        givenname: 'oid:2.5.4.42',
        surname: 'oid:2.5.4.4'
      }
    end

    def internal_aliases
      Hash[oids.map do |name, oid|
        [name, find_by(oid: oid)]
      end]
    end
  end

  # :nocov:
  rails_admin do
    label label.titleize

    list do
      field :primary_alias do
        label label.titleize
      end

      field :description
    end

    field :oid do
      label label.upcase
    end

    field :primary_alias
    field :federation_attribute_aliases
    field :http_header do
      label 'HTTP Header'
    end

    field :description
    field :singular

    field :regexp
    field :regexp_triggers_failure

    fields :primary_alias, :federation_attribute_aliases,
           :regexp_triggers_failure do
      label label.titleize
    end

    show do
      field :notes_on_format
      field :notes_on_usage
      field :notes_on_privacy

      field :created_at
      field :updated_at

      fields :notes_on_format, :notes_on_usage, :notes_on_privacy, :created_at,
             :updated_at do
        label label.titleize
      end
    end

    edit do
      field :notes_on_format, :ck_editor
      field :notes_on_usage, :ck_editor
      field :notes_on_privacy, :ck_editor

      fields :notes_on_format, :notes_on_usage, :notes_on_privacy do
        label label.titleize
      end
    end
  end
  # :nocov:
end
