# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :category_attributes
  has_many :federation_attributes, through: :category_attributes

  scope :enabled, -> { where(enabled: true) }

  valhammer

  # :nocov:
  rails_admin do
    field :name
    field :description
    field :order
    field :enabled
  end
  # :nocov:
end
