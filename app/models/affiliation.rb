# frozen_string_literal: true
# Class defining affiliation model
class Affiliation < ActiveRecord::Base
  belongs_to :subject
end
