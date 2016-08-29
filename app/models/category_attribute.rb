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

    field :created_at do
      read_only true
    end

    field :updated_at do
      read_only true
    end
  end
  # :nocov:
end
