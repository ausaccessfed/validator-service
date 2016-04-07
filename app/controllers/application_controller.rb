# frozen_string_literal: true
# Class for the main application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
