# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :category_attributes
  has_many :federation_attributes, through: :category_attributes

  scope :enabled, -> { where(enabled: true) }

  valhammer

  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

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
    field :created_at
    field :updated_at

    fields :created_at, :updated_at do
      read_only true
      label label.titleize
    end
  end
  # :nocov:
end
