# frozen_string_literal: true
class CategoryAttribute < ApplicationRecord
  belongs_to :category
  belongs_to :federation_attribute

  valhammer

  class << self
    def sort_by_order(enum)
      enum.sort_by { |key, _value| key[:order] }
    end
  end

  # :nocov:
  rails_admin do
    parent Category

    label label.titleize

    list do
      field :category do
        searchable [:name]
        queryable true
      end
      field :federation_attribute do
        # NOTE: This is not accurate, but close enough in most cases.
        searchable [:internal_alias]
        queryable true
        label label.titleize
      end
    end

    field :category

    field :federation_attribute do
      label label.titleize
    end

    field :presence

    show do
      field :created_at
      field :updated_at

      fields :created_at, :updated_at do
        label label.titleize
      end
    end
  end
  # :nocov:
end
