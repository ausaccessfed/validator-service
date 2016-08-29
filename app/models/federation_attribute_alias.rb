# frozen_string_literal: true
class FederationAttributeAlias < ApplicationRecord
  belongs_to :federation_attribute

  valhammer

  # :nocov:
  rails_admin do
    parent FederationAttribute

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
