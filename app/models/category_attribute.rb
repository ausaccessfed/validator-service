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
      field :federation_attribute do
        label label.titleize
      end
    end

    field :category

    field :federation_attribute do
      label label.titleize
    end

    field :presence

    field :created_at do
      read_only true
      label label.titleize
    end

    field :updated_at do
      read_only true
      label label.titleize
    end
  end
  # :nocov:
end
