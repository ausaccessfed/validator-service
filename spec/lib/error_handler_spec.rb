# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::ErrorHandler do
  let(:error_handler) { Authentication::ErrorHandler.new }

  describe '#handle' do
    it 'Exception to be raised' do
      expect { error_handler.handle(nil, nil)}.to raise_error
    end
  end
end
