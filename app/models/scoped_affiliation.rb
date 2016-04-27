# frozen_string_literal: true
# Class defining ScopedAffiliation model
class ScopedAffiliation < ActiveRecord::Base
  belongs_to :subject
end
