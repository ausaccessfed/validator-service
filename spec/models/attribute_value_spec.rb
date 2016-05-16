# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Attribute Values', type: :model do
  let(:attribute_value) { build :attribute_value }

  it { expect(attribute_value).to be_valid }

  it 'is invalid without a value' do
    attribute_value.value = nil
    expect(attribute_value).not_to be_valid
  end
end
