# frozen_string_literal: true

class ScopedAffiliation < ActiveRecord::Base
  belongs_to :subject
end
