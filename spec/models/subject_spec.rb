# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/subjects'

RSpec.describe Subject, type: :model do
  include_examples 'Subjects'

  describe '#admin?' do
    it 'is admin' do
      subject = FactoryGirl.create(:subject, :admin)

      expect(subject.admin?).to eql true
    end

    it 'is not admin' do
      subject = FactoryGirl.create(:subject)

      expect(subject.admin?).to eql false
    end
  end

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
    let(:subject) { Subject.create(attributes_for(:subject)) }

    let(:attrs) do
      Authentication::AttributeHelpers
        .federation_attributes(attributes_for(:shib_env)[:env])
    end

    before :each do
      create_federation_attributes
    end

    it 'is valid' do
      Snapshot.create_from_receiver(subject, attrs)
      Snapshot.create_from_receiver(subject, attrs)

      expect(subject.valid_identifier_history?).to eql true
    end

    it 'is invalid' do
      Snapshot.create_from_receiver(subject, attrs)
      Snapshot.create_from_receiver(
        subject,
        attrs.merge('HTTP_AUEDUPERSONSHAREDTOKEN' => '¯\_(ツ)_/¯')
      )

      expect(subject.valid_identifier_history?).to eql false
    end
  end

  context 'class' do
    let(:subject) { FactoryGirl.create(:subject) }

    before :each do
      create_federation_attributes
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
