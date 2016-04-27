# frozen_string_literal: true
# Class defining SubjectRole model
class SubjectRole < ActiveRecord::Base
  include Accession::Principal

  belongs_to :subject
  belongs_to :role

  valhammer
end
