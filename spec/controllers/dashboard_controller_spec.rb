# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:subject_obj) { create(:subject) }
  describe '#dashboard' do
    context 'when the user is logged in' do
      before do
        session[:subject_id] = subject_obj.id
        get :dashboard
      end

      it 'should render ok' do
        expect(response).to have_http_status(:ok)
      end

      it { is_expected.to render_template('dashboard/dashboard') }
    end
  end
end
