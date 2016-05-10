# frozen_string_literal: true
# Class defining Attribute model
class FederationAttribute < ActiveRecord::Base
  has_many :attribute_values

  valhammer

end
