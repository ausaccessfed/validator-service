# frozen_string_literal: true
class FederationAttributeAlias < ApplicationRecord
  belongs_to :federation_attribute

  # :nocov:
  rails_admin do
    parent FederationAttribute

    field :name
    field :federation_attribute
  end
  # :nocov:
end
