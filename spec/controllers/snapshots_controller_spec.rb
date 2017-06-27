# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnapshotsController, type: :controller do
  let(:admin_subject) { create(:subject, :admin) }
  let(:subject) { create(:subject) }
  let(:subject2) { create(:subject) }

  let(:attrs) do
    Authentication::AttributeHelpers
      .federation_attributes(attributes_for(:shib_env)[:env])
  end

  let!(:category) { create(:category) }

  let(:has_snapshot) do
    Snapshot.create_from_receiver(subject, attrs)
  end

  let(:admin_has_snapshot) do
    Snapshot.create_from_receiver(admin_subject, attrs)
  end

  let(:subject2_has_snapshot) do
    Snapshot.create_from_receiver(subject2, attrs)
  end

  before(:each) do
    create_federation_attributes(%i[targeted_id mail displayname])
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

  describe '#failed' do
    context 'when the user is logged in' do
      before do
        session[:subject_id] = subject.id
        session[:attributes] = attrs

        get :failed
      end

      it 'should render ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns' do
        expect(Snapshot.all.size).to eq 0
        expect(assigns(:snapshot)).to be_instance_of(Snapshot)

        expect(AttributeValue.all.size).to eq 0
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
        subject2_has_snapshot

        session[:subject_id] = subject.id
      end

      context 'own snapshot' do
        before(:each) do
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

      context "other subject's snapshot" do
        before(:each) do
          get :show, params: { id: subject2.snapshots.first }
        end

        it 'should render not found' do
          expect(response).to have_http_status(:not_found)
        end

        it 'assigns' do
          expect(assigns(:admin_viewer)).to eql nil
        end

        it { is_expected.to render_template('dynamic_errors/not_found') }
      end
    end

    context 'when admin is logged in' do
      before do
        admin_has_snapshot
        subject2_has_snapshot

        session[:subject_id] = admin_subject.id
      end

      context 'own snapshot' do
        before(:each) do
          get :show, params: { id: admin_subject.snapshots.first }
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

      context "other subject's snapshot" do
        before(:each) do
          get :show, params: { id: subject2.snapshots.first }
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

          expect(assigns(:admin_viewer)).to eql true
        end

        it { is_expected.to render_template('snapshots/show') }
      end
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
