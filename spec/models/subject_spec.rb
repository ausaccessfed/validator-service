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

  context 'class' do
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

    describe '.check_subject' do
      it 'calls' do
        attrs = {
          'HTTP_TARGETED_ID' => subject.targeted_id,
          'HTTP_AUEDUPERSONSHAREDTOKEN' => subject.auedupersonsharedtoken
        }

        expect(Subject).to(
          receive(:require_subject_match).with(subject,
                                               attrs,
                                               'HTTP_TARGETED_ID')
        )

        expect(Subject).to(
          receive(:require_subject_match).with(subject,
                                               attrs,
                                               'HTTP_AUEDUPERSONSHAREDTOKEN')
        )

        Subject.check_subject(subject, attrs)
      end
    end

    describe '.require_subject_match' do
      let(:auedupersonsharedtoken) { SecureRandom.urlsafe_base64(19) }

      it 'matches' do
        expect(Subject.require_subject_match(
                 subject,
                 {
                   'HTTP_AUEDUPERSONSHAREDTOKEN' =>
                    subject.auedupersonsharedtoken
                 },
                 'HTTP_AUEDUPERSONSHAREDTOKEN'
        )).to eql subject.auedupersonsharedtoken
      end

      it 'does not match' do
        expect do
          Subject.require_subject_match(
            subject,
            { 'HTTP_AUEDUPERSONSHAREDTOKEN' => auedupersonsharedtoken },
            'HTTP_AUEDUPERSONSHAREDTOKEN'
          )
        end.to(raise_error(
                 RuntimeError,
                 'Incoming HTTP_AUEDUPERSONSHAREDTOKEN ' \
                 "`#{auedupersonsharedtoken}` did not match existing ``"
        ))
      end
    end
  end
end
