class CategoryAttribute < ApplicationRecord
  belongs_to :category
  belongs_to :federation_attribute
end
