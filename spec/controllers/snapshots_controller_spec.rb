# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SnapshotsController, type: :controller do
  let(:subject) { create(:subject) }

  let(:attrs) do
    Authentication::AttributeHelpers
      .federation_attributes(attributes_for(:shib_env)[:env])
  end

  let!(:category) { create(:category) }

  let(:has_snapshot) do
    create_federation_attributes([:targeted_id, :mail, :displayname])

    Snapshot.create_from_receiver(subject, attrs)
  end

  describe '#latest' do
    context 'when the user is logged in' do
      before do
        has_snapshot

        session[:subject_id] = subject.id
        get :latest
      end

      it 'should render ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns' do
        expect(assigns(:snapshot)).to be_instance_of(Snapshot)

        expect(assigns(:attribute_values).size).to eql 3
        expect(assigns(:attribute_values).first)
          .to be_instance_of(AttributeValue)

        expect(assigns(:categories).size).to eql 1
        expect(assigns(:categories).first).to be_instance_of(Category)
      end

      it { is_expected.to render_template('snapshots/show') }
    end
  end

  describe '#show' do
    context 'when the user is logged in' do
      before do
        has_snapshot

        session[:subject_id] = subject.id
        get :show, params: { id: subject.snapshots.first }
      end

      it 'should render ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns' do
        expect(assigns(:snapshot)).to be_instance_of(Snapshot)

        expect(assigns(:attribute_values).size).to eql 3
        expect(assigns(:attribute_values).first)
          .to be_instance_of(AttributeValue)

        expect(assigns(:categories).size).to eql 1
        expect(assigns(:categories).first).to be_instance_of(Category)
      end

      it { is_expected.to render_template('snapshots/show') }
    end
  end

  describe '#index' do
    context 'when the user is logged in' do
      before do
        has_snapshot

        session[:subject_id] = subject.id
        get :index
      end

      it 'should render ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns' do
        expect(assigns(:snapshots).size).to eql 1
      end

      it { is_expected.to render_template('snapshots/index') }
    end
  end
end
