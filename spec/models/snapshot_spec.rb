# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Snapshot', type: :model do
  let(:snapshot) { build :snapshot }

  it { expect(snapshot).to be_valid }
end
