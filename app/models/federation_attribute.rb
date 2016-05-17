# frozen_string_literal: true
# Class defining Attribute model
class FederationAttribute < ActiveRecord::Base
  has_many :attribute_values

  valhammer

  def singular?
    return self.singular
  end
end
