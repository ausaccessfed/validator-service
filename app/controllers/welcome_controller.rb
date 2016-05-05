# frozen_string_literal: true
# Class for the Welcome Controller
class WelcomeController < ApplicationController
  skip_before_action :ensure_authenticated
  def index
    public_action
  end
end
