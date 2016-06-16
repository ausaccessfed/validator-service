# frozen_string_literal: true
class AttributeValue < ActiveRecord::Base
  has_many :snapshot_attribute_values
  has_one :snapshot, through: :snapshot_attribute_values

  belongs_to :federation_attribute

  valhammer
end
