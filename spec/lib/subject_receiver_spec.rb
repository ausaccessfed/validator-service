# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }

  describe '#subject' do
    let(:attrs) { attributes_for(:subject) }
    before do
      allow(subject_receiver).to receive(:update_affiliations).and_return nil
      allow(subject_receiver).to receive(:update_scoped_affiliations)
        .and_return nil
    end

    context 'creating subject' do
      it 'creates a new subject based on attrs' do
        expect { subject_receiver.subject({}, attrs) }
          .to change(Subject, :count).by(1)
      end
    end

    context 'updates an existing subject' do
      before { Subject.create(attrs) }
      it 'does not create a new subject if one already exists' do
        expect { subject_receiver.subject({}, attrs) }
          .to change(Subject, :count).by(0)
      end
      it 'updates the existing subject with the new attributes' do
        attrs[:o] = Faker::Company.name
        expect(subject_receiver.subject({}, attrs).o).to eql attrs[:o]
      end
    end

    context 'should slice the targeted_id of the subject that is created' do
      let(:result) { subject_receiver.subject({}, attrs) }
      it 'returns the correct targeted_id' do
        expect(result[:targeted_id]).to eql(attrs.slice(:targeted_id).values[0])
      end
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }
    it 'redirects to the dashboard page after a successful login' do
      expect(result).to eql([302, { 'Location' => '/dashboard' }, []])
    end
  end

  describe '#ensure_subject_match' do
    let(:subject) { create(:subject) }
    let(:attrs) { attributes_for(:subject) }

    before do
      attrs[:shared_token] = subject.shared_token
    end

    it 'is nil if the attributes match the existing subject' do
      expect(subject_receiver.ensure_subject_match(subject, attrs)).to be_nil
    end

    it 'raises an error if the shared_token does not match' do
      subject.shared_token = SecureRandom.urlsafe_base64(20)
      expect do
        subject_receiver.ensure_subject_match(subject, attrs)
      end.to raise_error('Subject mismatch')
    end

    it 'returns nil if the subject has not been persisted' do
      subject = build(:subject)
      expect(subject_receiver.ensure_subject_match(subject, attrs)).to be_nil
    end
  end

  describe '#update_affiliations' do
    let(:subject) { create(:subject) }
    let(:attrs) { build(:shib_attrs) }

    it 'creates a new affiliation record for each attribute' do
      expect do
        subject_receiver.update_affiliations(subject, attrs)
      end.to change(subject.affiliations, :count).by(2)
    end
  end

  describe '#update_scoped_affiliations' do
    let(:subject) { create(:subject) }
    let(:attrs) { build(:shib_attrs) }

    it 'creates a new scoped affiliation record for each attribute' do
      expect do
        subject_receiver.update_scoped_affiliations(subject, attrs)
      end.to change(subject.scoped_affiliations, :count).by(2)
    end
  end
end
