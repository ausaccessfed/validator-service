# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }

  let(:ide_config) do
    {
      host: 'ide.example.edu',
      cert: 'spec/api.crt',
      key: 'spec/api.key',
      admin_entitlements: ['urn:mace:aaf.edu.au:ide:internal:aaf-admin']
    }
  end

  let(:attrs) do
    Authentication::AttributeHelpers
      .federation_attributes(attributes_for(:shib_env)[:env])
  end

  before do
    allow(subject_receiver).to receive(:ide_config).and_return(ide_config)

    create_federation_attributes

    entitlement = 'urn:mace:aaf.edu.au:ide:internal:aaf-admin'

    stub_ide(shared_token: attrs['HTTP_AUEDUPERSONSHAREDTOKEN'],
             entitlements: [entitlement])
  end

  describe '#receive' do
    it 'continues if it has a targeted ID' do
      allow(subject_receiver).to receive(:map_attributes) do
        attributes_for(:shib_env)[:env]
      end

      env = { 'rack.session' => { 'subject_id' => 0 } }

      expect(subject_receiver.receive(env)).to eql(
        [302, { 'Location' => '/snapshots/latest' }, []]
      )
    end

    it 'redirects if it has no targeted ID' do
      allow(subject_receiver).to receive(:map_attributes) do
        envs = attributes_for(:shib_env)[:env]
        envs.delete('HTTP_TARGETED_ID')

        envs
      end

      expect(subject_receiver.receive({})).to eql(
        [302, { 'Location' => '/?no_targeted_id=true' }, []]
      )
    end
  end

  describe '#subject' do
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
            HTTP_DISPLAYNAME
            HTTP_CN
            HTTP_EPPN
            HTTP_MAIL
            HTTP_O
            HTTP_HOMEORGANIZATION
            HTTP_HOMEORGANIZATIONTYPE
            HTTP_UNSCOPED_AFFILIATION
            HTTP_SCOPED_AFFILIATION
          )
        )
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }

    it 'redirects to the latest snapshot after a successful login' do
      expect(result).to eql([302, { 'Location' => '/snapshots/latest' }, []])
    end
  end

  describe '#assign_entitlements' do
    let(:subject) { FactoryGirl.create(:subject) }

    before :each do
      FactoryGirl.create(
        :role,
        entitlement: 'urn:mace:aaf.edu.au:ide:internal:aaf-admin'
      )
      FactoryGirl.create(:permission, value: 'app:validator:admin:*')
    end

    it 'assigns roles' do
      expect(subject.roles.size).to eql 0

      subject_receiver.send(:assign_entitlements,
                            subject,
                            ['urn:mace:aaf.edu.au:ide:internal:aaf-admin'])

      expect(subject.roles.size).to eql 1
    end

    it 'removes roles' do
      expect(subject.roles.size).to eql 0
      subject_receiver.send(:assign_entitlements,
                            subject,
                            ['urn:mace:aaf.edu.au:ide:internal:aaf-admin'])
      expect(subject.roles.size).to eql 1

      subject_receiver.send(:assign_entitlements, subject, [])

      expect(subject.roles.reload.size).to eql 0
    end
  end
end
