# frozen_string_literal: true
class FederationAttribute < ApplicationRecord
  has_many :category_attributes
  has_many :categories, through: :category_attributes

  has_many :federation_attribute_aliases
  has_many :attribute_values

  belongs_to :primary_alias, class_name: FederationAttributeAlias

  valhammer

  after_commit :sync_name, on: [:create, :update]

  scope :fuzzy_lookup, lambda { |id|
    alias_lookup(id) + where(oid: id)
  }

  scope :alias_lookup, lambda { |id|
    includes(:federation_attribute_aliases)
      .where(federation_attribute_aliases: { name: id })
  }

  scope :name_ordered, lambda {
    includes(:federation_attribute_aliases)
      .order('federation_attribute_aliases.name')
  }

  def aliases
    federation_attribute_aliases.where
                                .not(federation_attribute_aliases:
                                  { id: primary_alias_id })
  end

  def sync_name
    update_attribute(:primary_alias_name, primary_alias.name)
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
  end

  def custom_label_method
    primary_alias_name
  end

  # :nocov:
  rails_admin do
    object_label_method do
      :custom_label_method
    end

    label label.titleize

    list do
      field :primary_alias do
        searchable [:primary_alias_name]
        queryable true
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
      field :notes_on_format
      field :notes_on_usage
      field :notes_on_privacy

      fields :notes_on_format, :notes_on_usage, :notes_on_privacy do
        label label.titleize
      end
    end
  end
  # :nocov:
end
