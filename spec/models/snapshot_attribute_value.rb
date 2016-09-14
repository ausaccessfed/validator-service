# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Snapshot Attribute Values', type: :model do
  let(:snapshot_attribute_values) { build :snapshot_attribute_values }

  it { expect(snapshot_attribute_values).to be_valid }
end
