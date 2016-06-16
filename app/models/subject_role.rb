# frozen_string_literal: true
class SubjectRole < ActiveRecord::Base
  include Accession::Principal

  belongs_to :subject
  belongs_to :role

  valhammer
end
