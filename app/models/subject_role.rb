# frozen_string_literal: true
class SubjectRole < ApplicationRecord
  include Accession::Principal

  belongs_to :subject
  belongs_to :role

  valhammer
end
