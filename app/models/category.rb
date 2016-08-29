# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :category_attributes
  has_many :federation_attributes, through: :category_attributes

  scope :enabled, -> { where(enabled: true) }

  valhammer

  # :nocov:
  rails_admin do
    list do
      field :name
      field :description
    end

    field :name
    field :description
    field :order
    field :enabled

    field :created_at do
      read_only true
    end

    field :updated_at do
      read_only true
    end
  end
  # :nocov:
end
