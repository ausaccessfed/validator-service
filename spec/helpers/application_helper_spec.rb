# frozen_string_literal: true

require 'rails_helper'
describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#application_version' do
    it 'returns the correct version number' do
      expect(application_version).to eql ValidatorService::Application::VERSION
    end
    it 'conforms to the semver format' do
      expect(/^\d+.\d+.\d+([-+]\S+)?$/.match(application_version)).to be_truthy
    end
  end
end
