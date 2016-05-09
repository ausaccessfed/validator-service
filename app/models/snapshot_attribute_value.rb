# frozen_string_literal: true
# Class defining AttributeValue model
class SnapshotAttributeValue < ActiveRecord::Base
  belongs_to :snapshot
  belongs_to :attribute_value
end
