# frozen_string_literal: true
class CategoryAttribute < ApplicationRecord
  belongs_to :category
  belongs_to :federation_attribute

  valhammer

  # :nocov:
  rails_admin do
    parent Category

    list do
      field :category
      field :federation_attribute
    end

    field :category
    field :federation_attribute
    field :presence

    field :created_at
    field :updated_at

    fields :created_at, :updated_at, :federation_attribute do
      label label.titleize
    end

    fields :created_at, :updated_at do
      read_only true
    end
  end
  # :nocov:
end
