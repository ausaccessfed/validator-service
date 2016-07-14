# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :category_attributes
  has_many :federation_attributes, through: :category_attributes
end
