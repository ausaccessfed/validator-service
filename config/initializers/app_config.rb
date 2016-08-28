# frozen_string_literal: true

Rails.application.configure do
  app_config = YAML.load(Rails.root.join('config/validator_service.yml').read)
  config.validator_service = OpenStruct.new(app_config.deep_symbolize_keys)

  if Rails.env.test?
    config.validator_service.ide = {
      host: 'ide.example.edu',
      cert: 'spec/api.crt',
      key: 'spec/api.key',
      admin_entitlements: ['urn:mace:aaf.edu.au:ide:internal:aaf-admin',
                           'urn:mace:aaf.edu.au:ide:internal:aaf-validator']
    }

    config.validator_service.url_options = { base_url: 'example.com' }

    config.validator_service.environment_string = 'Test'
  end
end
