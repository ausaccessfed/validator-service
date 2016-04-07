# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

module ValidatorService
  class Application < Rails::Application
  end
end
