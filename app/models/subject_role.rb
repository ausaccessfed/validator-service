# frozen_string_literal: true
# Model for the subject_role table
class SubjectRole < ActiveRecord::Base
  include Accession::Principal

  belongs_to :subject
  belongs_to :role

  valhammer
end
