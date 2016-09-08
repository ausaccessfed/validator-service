# frozen_string_literal: true
require 'rails_helper'
require 'gumboot/shared_examples/roles'

RSpec.describe Role, type: :model do
  include_examples 'Roles'

  let(:admin) { 'a:b:c:admin' }
  let(:admin_validator) { 'a:b:c:validator' }
  let(:prefix) { 'a:b:c' }

  let(:config) do
    { admin_entitlements: [admin, admin_validator] }
  end

  before do
    allow(Rails.application)
      .to receive_message_chain(:config, :validator_service, :ide)
      .and_return(config)
  end
end
