# frozen_string_literal: true
class AddTimestampsToFederationAttributes < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :federation_attributes
  end
end
