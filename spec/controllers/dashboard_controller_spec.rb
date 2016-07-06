# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:subject) { create(:subject) }
  let(:attrs) do
    Authentication::AttributeHelpers
      .federation_attributes(attributes_for(:shib_env)[:env])
  end
  let(:has_snapshot) { Snapshot.create_from_receiver(subject, attrs) }

  describe '#dashboard' do
    context 'when the user is logged in' do
      before do
        has_snapshot

        session[:subject_id] = subject.id
        get :dashboard
      end

      it 'should render ok' do
        expect(response).to have_http_status(:ok)
      end

      it { is_expected.to render_template('dashboard/dashboard') }
    end
  end
end
