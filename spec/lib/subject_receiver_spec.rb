# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }

  describe '#subject' do
    let(:attrs) { build(:shib_attrs) }

    context 'creating subject and associated records' do
      let(:subject) { subject_receiver.subject({}, attrs) }

      it 'persists a subject record' do
        expect(subject).to be_persisted
      end

      describe 'create a subject record with the correct attributes' do
        it 'has the correct targeted_id' do
          expect(subject.targeted_id).to eql attrs[:targeted_id]
        end
        it 'has the correct name' do
          expect(subject.name).to eql attrs[:name]
        end
        it 'has the correct email' do
          expect(subject.mail).to eql attrs[:mail]
        end
        it 'is enabled' do
          expect(subject.enabled).to eql true
        end
        it 'is complete' do
          expect(subject.complete).to eql true
        end
      end
    end

    context 'updates an existing subject' do
      let(:subject) { Subject.create(attributes_for(:subject)) }
      it 'does not create a new subject if one already exists' do
        attrs = build(:shib_attrs)
        attrs[:targeted_id] = subject.targeted_id
        expect { subject_receiver.subject({}, attrs) }
          .to change(Subject, :count).by(0)
      end
      it 'updates the existing subject with the new name attributes' do
        attrs[:name] = Faker::Name.name
        expect(subject_receiver.subject({}, attrs).name).to eql attrs[:name]
      end
      it 'updates the existing subject with the new mail attributes' do
        attrs[:mail] = Faker::Internet.email
        expect(subject_receiver.subject({}, attrs).mail).to eql attrs[:mail]
      end
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }
    it 'redirects to the dashboard page after a successful login' do
      expect(result).to eql([302, { 'Location' => '/dashboard' }, []])
    end
  end
end
