# frozen_string_literal: true
class SnapshotAttributeValue < ApplicationRecord
  belongs_to :snapshot
  belongs_to :attribute_value

  valhammer
end
