# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::AttributeHelpers do
  subject { Authentication::AttributeHelpers }

  let(:http_headers) do
    %w(
      HTTP_TARGETED_ID
      HTTP_AUEDUPERSONSHAREDTOKEN
      HTTP_DISPLAYNAME
      HTTP_COMMONNAME
      HTTP_PRINCIPALNAME
      HTTP_MAIL
      HTTP_O
      HTTP_HOMEORGANIZATION
      HTTP_HOMEORGANIZATIONTYPE
      HTTP_EDUPERSONAFFILIATION
      HTTP_EDUPERSONSCOPEDAFFILIATION
    )
  end

  let(:shib_env) { attributes_for(:shib_env)[:env] }

  describe '.federation_attributes' do
    it 'filters out only federation attributes' do
      expect(subject.federation_attributes(shib_env).keys)
        .to eql(http_headers)
    end
  end
end
