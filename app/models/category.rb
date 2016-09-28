# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :category_attributes
  has_many :federation_attributes, through: :category_attributes

  scope :enabled, -> { where(enabled: true) }

  valhammer

  validates :order, numericality:
    { only_integer: true, greater_than_or_equal_to: 1 }

  def validation_order(all_attribute_values)
    CategoryAttribute.sort_by_order(grouped_attributes(all_attribute_values))
  end

  def matched_attributes(all_attribute_values)
    federation_attributes.name_ordered.map do |fa|
      attribute_values = all_attribute_values.select do |av|
        fa.id == av.federation_attribute_id
      end

      attribute_values = [nil] if attribute_values.empty?

      [fa, attribute_values.map { |x| x.try(:value) }]
    end
  end

  def grouped_attributes(all_attribute_values)
    matched_attributes(all_attribute_values).group_by do |fa, values|
      states = values.map do |value|
        AttributeValue.validation_state(self, fa, value)
      end

      CategoryAttribute.sort_by_order(states).first
    end.to_a
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
