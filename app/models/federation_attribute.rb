# frozen_string_literal: true
class FederationAttribute < ApplicationRecord
  has_many :category_attributes
  has_many :categories, through: :category_attributes

  has_many :federation_attribute_aliases
  has_many :attribute_values

  belongs_to :primary_alias, class_name: FederationAttributeAlias

  valhammer

  delegate :name, to: :primary_alias, allow_nil: true

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
  end

  # :nocov:
  rails_admin do
    object_label_method do
      :custom_label_method
    end

    field :oid
    field :primary_alias
    field :federation_attribute_aliases

    field :http_header
    field :description
    field :singular

    field :regexp
    field :regexp_triggers_failure
    field :notes_on_format, :ck_editor

    field :notes_on_usage, :ck_editor
    field :notes_on_privacy, :ck_editor
  end
  # :nocov:

  def custom_label_method
    "#{oid} (#{name})"
  end
end
