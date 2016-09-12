# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :category_attributes
  has_many :federation_attributes, through: :category_attributes

  scope :enabled, -> { where(enabled: true) }

  valhammer

  validates :order, numericality:
    { only_integer: true, greater_than_or_equal_to: 1 }

  def validation_order(attribute_values)
    ordered_attributes = federation_attributes
      .includes(:federation_attribute_aliases)
      .order('federation_attribute_aliases.name')

    matched_attributes = Hash[ordered_attributes.map do |fa|
      value = attribute_values.find_by(federation_attribute: fa).try(:value)

      [fa, value]
    end]

    grouped_attributes = matched_attributes.group_by do |fa, value|
      AttributeValue.validation_state(self, fa, value)
    end

    grouped_attributes.sort_by { |key, value| key[:order] }
  end

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
    field :federation_attributes do
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
