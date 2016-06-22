# frozen_string_literal: true
module ApplicationHelper
  include Lipstick::Helpers::LayoutHelper
  include Lipstick::Helpers::NavHelper
  include Lipstick::Helpers::FormHelper

  def application_version
    ValidatorService::Application::VERSION
  end
end
