# frozen_string_literal: true
# Class defining permission model
class Permission < ActiveRecord::Base
  belongs_to :role

  valhammer

  validates :value, format: Accession::Permission.regexp
end
