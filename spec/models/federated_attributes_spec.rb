# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Federation Attributes', type: :model do

  let(:federation_attribute) { build :federation_attribute }

  it { expect(federation_attribute).to be_valid }

  it 'is invalid without a name' do
    federation_attribute.name = nil
    expect(federation_attribute).not_to be_valid
  end

  it 'is invalid without a regexp_triggers_failure value' do
    federation_attribute.regexp_triggers_failure = nil
    expect(federation_attribute).not_to be_valid
  end

  it 'is invalid without a singular' do
    federation_attribute.singular = nil
    expect(federation_attribute).not_to be_valid
  end

end
