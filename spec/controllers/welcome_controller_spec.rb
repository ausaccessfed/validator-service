# frozen_string_literal: true
require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe '#welcome' do
    before do
      get :index
    end

    it 'should render ok' do
      expect(response).to have_http_status(:ok)
    end

    it { is_expected.to render_template('welcome/index') }
  end
end
