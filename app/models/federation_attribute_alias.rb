# frozen_string_literal: true
class FederationAttributeAlias < ApplicationRecord
  belongs_to :federation_attribute

  valhammer

  # :nocov:
  rails_admin do
    parent FederationAttribute

    list do
      field :name
      field :federation_attribute
    end

    field :name
    field :federation_attribute

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
