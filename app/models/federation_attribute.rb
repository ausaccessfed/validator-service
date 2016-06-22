# frozen_string_literal: true
class FederationAttribute < ActiveRecord::Base
  has_many :attribute_values

  valhammer
end
