# frozen_string_literal: true
# Class defining Snapshot model
class Snapshot < ActiveRecord::Base
  has_many :snapshot_attribute_values
  has_many :attribute_values, through: :snapshot_attribute_values
  belongs_to :subject

  valhammer

end
