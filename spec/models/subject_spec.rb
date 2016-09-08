# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/subjects'

RSpec.describe Subject, type: :model do
  include_examples 'Subjects'

  context 'subject#permissions' do
    let(:subject) { FactoryGirl.create(:subject) }
    let(:permission) { FactoryGirl.create(:permission) }
    let(:role) { FactoryGirl.create(:role) }

    it 'subject with no permissions' do
      expect(subject.permissions).to eq []
    end

    it 'subject with one role and permission' do
      role.permissions << permission
      subject.roles << role

      expect(subject.permissions).to eq [
        subject.roles.first.permissions.first.value
      ]
    end

    context 'subjects with multiple roles and permissions' do
      before do
        rand(1..10).times do
          r = FactoryGirl.build(:role)
          rand(1..10).times do
            r.permissions << FactoryGirl.build(:permission)
          end
          subject.roles << r
        end
      end

      it 'subject has multiple roles with multiple permissions' do
        res = []
        subject.roles.each do |result|
          result.permissions.each do |permission|
            res << permission.value
          end
        end

        expect(subject.permissions).to eq res
      end
    end
  end

  context 'subject#functioning?' do
    let(:subject) { FactoryGirl.create(:subject) }
    context 'subject is functioning' do
      it 'is functioning' do
        expect(subject.functioning?).to eq true
      end
    end

    context 'subject is not functioning' do
      before { subject.enabled = false }
      it 'is not functioning' do
        expect(subject.functioning?).to eq false
      end
    end
  end

  describe '#valid_identifier_history?' do
    let(:subject) { FactoryGirl.create(:subject) }

    it 'is valid' do
      expect(subject.valid_identifier_history?).to eql true
    end

    describe 'is invalid' do
      it 'invalid targeted id' do
        future_time = DateTime.current + 10.minutes

        FactoryGirl.create(
          :subject,
          targeted_id: subject.targeted_id,
          created_at: future_time,
          updated_at: future_time
        )

        expect(subject.valid_identifier_history?).to eql false
      end

      it 'invalid auedupersonsharedtoken' do
        future_time = DateTime.current + 10.minutes

        FactoryGirl.create(
          :subject,
          auedupersonsharedtoken: subject.auedupersonsharedtoken,
          created_at: future_time,
          updated_at: future_time
        )

        expect(subject.valid_identifier_history?).to eql false
      end
    end
  end

  describe '#entitlements=' do
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

      subject.entitlements = ['urn:mace:aaf.edu.au:ide:internal:aaf-admin']

      expect(subject.roles.size).to eql 1
    end

    it 'removes roles' do
      expect(subject.roles.size).to eql 0
      subject.entitlements = ['urn:mace:aaf.edu.au:ide:internal:aaf-admin']
      expect(subject.roles.size).to eql 1

      subject.entitlements = []

      expect(subject.roles.reload.size).to eql 0
    end
  end

  context 'class' do
    let(:subject) { FactoryGirl.create(:subject) }

    describe '.from_attributes' do
      describe 'finds record' do
        it 'by targeted_id' do
          result = Subject.from_attributes(
            'HTTP_TARGETED_ID' => subject.targeted_id,
            'HTTP_AUEDUPERSONSHAREDTOKEN' => ''
          )

          expect(result.count).to eql 1
          expect(result.first).to eql subject
        end

        it 'by auedupersonsharedtoken' do
          result = Subject.from_attributes(
            'HTTP_TARGETED_ID' => '',
            'HTTP_AUEDUPERSONSHAREDTOKEN' =>
              subject.auedupersonsharedtoken
          )

          expect(result.count).to eql 1
          expect(result.first).to eql subject
        end

        it 'by both' do
          result = Subject.from_attributes(
            'HTTP_TARGETED_ID' => subject.targeted_id,
            'HTTP_AUEDUPERSONSHAREDTOKEN' =>
              subject.auedupersonsharedtoken
          )

          expect(result.count).to eql 1
          expect(result.first).to eql subject
        end
      end

      it 'does not find record' do
        expect(Subject.from_attributes(
          'HTTP_TARGETED_ID' => '',
          'HTTP_AUEDUPERSONSHAREDTOKEN' => ''
        ).count).to eql 0
      end
    end

    describe '.most_recent' do
      describe 'finds record' do
        describe 'chooses the most recent subject' do
          it 'with invalid targeted id' do
            future_time = DateTime.current + 10.minutes

            subject2 = FactoryGirl.create(
              :subject,
              targeted_id: subject.targeted_id,
              created_at: future_time,
              updated_at: future_time
            )

            expect(
              Subject.most_recent(
                'HTTP_TARGETED_ID' => subject.targeted_id,
                'HTTP_AUEDUPERSONSHAREDTOKEN' =>
                  subject.auedupersonsharedtoken
              )
            ).to eql subject2
          end

          it 'with invalid auedupersonsharedtoken' do
            future_time = DateTime.current + 10.minutes

            subject2 = FactoryGirl.create(
              :subject,
              auedupersonsharedtoken: subject.auedupersonsharedtoken,
              created_at: future_time,
              updated_at: future_time
            )

            expect(
              Subject.most_recent(
                'HTTP_TARGETED_ID' => subject.targeted_id,
                'HTTP_AUEDUPERSONSHAREDTOKEN' =>
                  subject.auedupersonsharedtoken
              )
            ).to eql subject2
          end
        end
      end

      it 'does not find record' do
        expect(Subject.most_recent(
                 'HTTP_TARGETED_ID' => '',
                 'HTTP_AUEDUPERSONSHAREDTOKEN' => ''
        )).to eql nil
      end
    end

    describe '.combined_name' do
      let(:given_name) do
        Faker::Name.first_name
      end

      let(:surname) do
        Faker::Name.last_name
      end

      it 'has given' do
        expect(Subject.combined_name('HTTP_GIVENNAME' => given_name)).to eql(
          given_name
        )
      end

      it 'has surname' do
        expect(Subject.combined_name('HTTP_SURNAME' => surname)).to eql(
          surname
        )
      end

      it 'has both' do
        expect(Subject.combined_name('HTTP_GIVENNAME' => given_name,
                                     'HTTP_SURNAME' => surname)).to eql(
                                       given_name + ' ' + surname
                                     )
      end

      it 'has neither' do
        expect(Subject.combined_name({})).to eql(
          ''
        )
      end
    end
  end
end
