# frozen_string_literal: true
# Class defining AttributeValue model
class AttributeValue < ActiveRecord::Base
  has_many :snapshot_attribute_values
  has_many :snapshots, through: :snapshot_attribute_values

  belongs_to :aaf_attribute
  serialize :value
end
