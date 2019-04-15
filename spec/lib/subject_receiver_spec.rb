# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }

  let(:attrs) do
    Authentication::AttributeHelpers
      .federation_attributes(attributes_for(:shib_env)[:env])
  end

  let(:rack_env) do
    { 'rack.session' => {} }
  end

  before do
    create_federation_attributes

    entitlement = 'urn:mace:aaf.edu.au:ide:internal:aaf-admin'
    FactoryBot.create(:role, entitlement: entitlement)
  end

  describe '#receive' do
    describe 'required info' do
      it 'valid with targeted id and Mail' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs.delete('HTTP_TARGETED_ID')
          envs
        end

        rack_env['rack.session']['subject_id'] = 0

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/latest' }, []]
        )
      end

      it 'valid with persistent id and Mail' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs.delete('HTTP_TARGETED_ID')
          envs
        end

        rack_env['rack.session']['subject_id'] = 0

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/latest' }, []]
        )
      end

      it 'valid with persistent id, targeted id and Mail' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs.delete('HTTP_TARGETED_ID')
          envs
        end

        rack_env['rack.session']['subject_id'] = 0

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/latest' }, []]
        )
      end

      it 'fails without persistent id or targeted id' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs.delete('HTTP_PERSISTENT_ID')
          envs.delete('HTTP_TARGETED_ID')
          envs
        end

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/failed' }, []]
        )
      end

      it 'fails with empty persistent id and targeted id' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs['HTTP_PERSISTENT_ID'] = ''
          envs['HTTP_TARGETED_ID'] = ''

          envs
        end

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/failed' }, []]
        )
      end

      it 'fails without mail' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs.delete('HTTP_MAIL')

          envs
        end

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/failed' }, []]
        )
      end

      it 'fails with empty mail' do
        allow(subject_receiver).to receive(:map_attributes) do
          envs = attributes_for(:shib_env)[:env]
          envs['HTTP_MAIL'] = ''

          envs
        end

        expect(subject_receiver.receive(rack_env)).to eql(
          [302, { 'Location' => '/snapshots/failed' }, []]
        )
      end
    end
  end

  describe '#subject' do
    context 'creating subject and associated records' do
      describe 'create a subject record with the correct attributes' do
        let(:subject) { subject_receiver.subject({}, attrs) }

        context 'federated identifier' do
          context 'when a persistent id is provided' do
            it 'Sets federated id to persistent id' do
              expect(subject.persistent_id).to eql attrs['HTTP_PERSISTENT_ID']
            end
          end

          context 'when only a targeted id is provided' do
            before { attrs.delete('HTTP_PERSISTENT_ID') }

            it 'Sets federated id to targeted id' do
              expect(subject.persistent_id).to eql attrs['HTTP_TARGETED_ID']
            end
          end
        end

        it 'persists a subject record' do
          expect(subject).to be_persisted
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

      context 'with persistent id' do
        before { attrs['HTTP_PERSISTENT_ID'] = subject.persistent_id }

        it 'does not create a new subject if one already exists' do
          expect { subject_receiver.subject({}, attrs) }
            .to change(Subject, :count).by(0)
        end

        it 'updates the existing subject with the new name attributes' do
          attrs['HTTP_DISPLAYNAME'] = Faker::Name.name

          expect(subject_receiver.subject({}, attrs).name)
            .to eql attrs['HTTP_DISPLAYNAME']
        end

        it 'updates the existing subject with the new mail attributes' do
          attrs['HTTP_MAIL'] = Faker::Internet.email

          expect(subject_receiver.subject({}, attrs).mail)
            .to eql attrs['HTTP_MAIL']
        end
      end

      context 'with targeted id' do
        before do
          attrs.delete('HTTP_PERSISTENT_ID')
          attrs['HTTP_TARGETED_ID'] = subject.persistent_id
        end

        it 'does not create a new subject if one already exists' do
          expect { subject_receiver.subject({}, attrs) }
            .to change(Subject, :count).by(0)
        end

        it 'updates the existing subject with the new name attributes' do
          attrs['HTTP_DISPLAYNAME'] = Faker::Name.name

          expect(subject_receiver.subject({}, attrs).name)
            .to eql attrs['HTTP_DISPLAYNAME']
        end

        it 'updates the existing subject with the new mail attributes' do
          attrs['HTTP_MAIL'] = Faker::Internet.email

          expect(subject_receiver.subject({}, attrs).mail)
            .to eql attrs['HTTP_MAIL']
        end
      end
    end
  end

  describe '#map_attributes' do
    it 'gets federation attributes' do
      expect(subject_receiver
        .map_attributes(attributes_for(:shib_env)[:env]).keys).to eql(
          %w[
            HTTP_PERSISTENT_ID
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
          ]
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
    let(:subject) { FactoryBot.create(:subject) }

    before :each do
      FactoryBot.create(:permission, value: 'app:validator:admin:*')
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

    it 'handles roles not available' do
      expect(subject.roles.size).to eql 0

      subject_receiver.send(:assign_entitlements,
                            subject,
                            ['urn:mace:aaf.edu.au:ide:researcher:1'])

      expect(subject.roles.size).to eql 0
    end
  end
end
