# frozen_string_literal: true
class FederationAttributeAlias < ApplicationRecord
  belongs_to :federation_attribute

  valhammer

  # :nocov:
  rails_admin do
    parent FederationAttribute

    label label.titleize

    list do
      field :name
      field :federation_attribute do
        label label.titleize
      end
    end

    field :name
    field :federation_attribute do
      label label.titleize
    end

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
