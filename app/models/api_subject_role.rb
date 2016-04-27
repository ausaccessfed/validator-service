# frozen_string_literal: true
# Model for the api_subject_role table
class APISubjectRole < ActiveRecord::Base
  include Accession::Principal

  belongs_to :api_subject
  belongs_to :role

  valhammer
end
