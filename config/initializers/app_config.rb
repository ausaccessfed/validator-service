# frozen_string_literal: true

Rails.application.configure do
  if Rails.env.test?
    config.validator_service.url_options = { base_url: 'example.com' }

    config.validator_service.environment_string = 'Test'
  end
  Time::DATE_FORMATS[:validator_date_format] = '%A, %d %B at %H:%M:%S %Z'
end
