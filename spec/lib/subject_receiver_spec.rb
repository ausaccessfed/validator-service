# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }

  describe '#subject' do
    let(:attrs) do
      Authentication::AttributeHelpers
        .federation_attributes(attributes_for(:shib_env)[:env])
    end

    before :each do
      %w(HTTP_TARGETED_ID HTTP_MAIL HTTP_DISPLAYNAME).each do |http_header|
        create(:federation_attribute, http_header: http_header)
      end
    end

    context 'creating subject and associated records' do
      let(:subject) { subject_receiver.subject({}, attrs) }

      it 'persists a subject record' do
        expect(subject).to be_persisted
      end

      describe 'create a subject record with the correct attributes' do
        it 'has the correct targeted_id' do
          expect(subject.targeted_id).to eql attrs['HTTP_TARGETED_ID']
        end

        it 'has the correct name' do
          expect(subject.name).to eql attrs['HTTP_DISPLAYNAME']
        end

        it 'has the correct email' do
          expect(subject.mail).to eql attrs['HTTP_MAIL']
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
      let!(:subject) do
        Subject.create(attributes_for(:subject))
      end

      it 'does not create a new subject if one already exists' do
        attrs['HTTP_TARGETED_ID'] = subject.targeted_id

        expect { subject_receiver.subject({}, attrs) }
          .to change(Subject, :count).by(0)
      end

      it 'updates the existing subject with the new name attributes' do
        attrs.merge!(
          'HTTP_TARGETED_ID' => subject.targeted_id,
          'HTTP_DISPLAYNAME' => Faker::Name.name
        )

        expect(subject_receiver.subject({}, attrs).name)
          .to eql attrs['HTTP_DISPLAYNAME']
      end

      it 'updates the existing subject with the new mail attributes' do
        attrs.merge!(
          'HTTP_TARGETED_ID' => subject.targeted_id,
          'HTTP_MAIL' => Faker::Internet.email
        )

        expect(subject_receiver.subject({}, attrs).mail)
          .to eql attrs['HTTP_MAIL']
      end
    end
  end

  describe '#map_attributes' do
    it 'gets federation attributes' do
      expect(subject_receiver
        .map_attributes(attributes_for(:shib_env)[:env]).keys).to eql(
          %w(
            HTTP_TARGETED_ID
            HTTP_AUEDUPERSONSHAREDTOKEN
            HTTP_DISPLAYNAME HTTP_CN
            HTTP_PRINCIPALNAME
            HTTP_MAIL
            HTTP_O
            HTTP_HOMEORGANIZATION
            HTTP_HOMEORGANIZATIONTYPE
            HTTP_EDUPERSONAFFILIATION
            HTTP_EDUPERSONSCOPEDAFFILIATION
          )
        )
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }

    it 'redirects to the dashboard page after a successful login' do
      expect(result).to eql([302, { 'Location' => '/dashboard' }, []])
    end
  end
end
