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

    field :created_at do
      read_only true
    end

    field :updated_at do
      read_only true
    end
  end
  # :nocov:
end
