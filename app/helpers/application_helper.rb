# frozen_string_literal: true
# Module for the main application_helper
module ApplicationHelper
  include Lipstick::Helpers::LayoutHelper
  include Lipstick::Helpers::NavHelper
  include Lipstick::Helpers::FormHelper

  def application_version
    return ValidatorService::Application::VERSION
  end

end
