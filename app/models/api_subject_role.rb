# frozen_string_literal: true

class APISubjectRole < ApplicationRecord
  include Accession::Principal

  belongs_to :api_subject
  belongs_to :role

  valhammer
end
