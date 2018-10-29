# frozen_string_literal: true

class FederationAttribute < ApplicationRecord
  include FederationAttributeAdmin

  has_many :category_attributes, dependent: :destroy

  has_many :categories,
           through: :category_attributes,
           dependent: :destroy,
           inverse_of: false

  has_many :federation_attribute_aliases, dependent: :destroy
  has_many :attribute_values, dependent: :destroy
  belongs_to :primary_alias, class_name: FederationAttributeAlias

  valhammer

  after_commit :sync_name, on: %i[create update]

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
    # This uses `#update_attribute` due to the `after_commit` hook
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:primary_alias_name, primary_alias.name)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def custom_label_method
    primary_alias_name
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
end
