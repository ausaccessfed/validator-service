# frozen_string_literal: true
# Class defining Attribute model
class AafAttribute < ActiveRecord::Base
  has_many :attribute_values  
end
