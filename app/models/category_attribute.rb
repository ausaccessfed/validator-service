# frozen_string_literal: true
class CategoryAttribute < ApplicationRecord
  belongs_to :category
  belongs_to :federation_attribute

  valhammer

  # :nocov:
  rails_admin do
    parent Category

    label label.titleize

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
