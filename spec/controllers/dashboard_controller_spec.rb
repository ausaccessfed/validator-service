# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:subject) { create(:subject) }

  let(:attrs) do
    Authentication::AttributeHelpers
      .federation_attributes(attributes_for(:shib_env)[:env])
  end

  let!(:category) { create(:category) }

  let(:has_snapshot) do
    %w(HTTP_TARGETED_ID HTTP_MAIL HTTP_DISPLAYNAME).each do |http_header|
      faa = FederationAttributeAlias.create!(
        name: http_header.sub('HTTP_', '').downcase
      )

      create(:federation_attribute,
             http_header: http_header,
             federation_attribute_aliases: [faa],
             primary_alias: faa)
    end

    Snapshot.create_from_receiver(subject, attrs)
  end

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

      it 'assigns' do
        expect(assigns(:latest_snapshot)).to be_instance_of(Snapshot)

        expect(assigns(:snapshot_values).size).to eql 3
        expect(assigns(:snapshot_values).first)
          .to be_instance_of(AttributeValue)

        expect(assigns(:categories).size).to eql 1
        expect(assigns(:categories).first).to be_instance_of(Category)
      end

      it { is_expected.to render_template('dashboard/dashboard') }
    end
  end
end
