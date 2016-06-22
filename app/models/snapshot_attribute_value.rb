# frozen_string_literal: true
class SnapshotAttributeValue < ActiveRecord::Base
  belongs_to :snapshot
  belongs_to :attribute_value

  valhammer
end
