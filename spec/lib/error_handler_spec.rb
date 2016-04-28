# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::ErrorHandler do
  let(:error_handler) { Authentication::ErrorHandler.new }

  describe '#handle' do
    it 'Exception to be raised' do
      expect do
        error_handler.handle(nil, 'Some Exception')
      end.to raise_error('Some Exception')
    end
  end
end
