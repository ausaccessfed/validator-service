# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/api_subjects'

RSpec.describe APISubject, type: :model do
  include_examples 'API Subjects'

  context 'api_subject#permissions' do
    let(:api_subject) { FactoryGirl.create(:api_subject) }
    let(:permission) { FactoryGirl.create(:permission) }
    let(:role) { FactoryGirl.create(:role) }

    it 'api subject with no permissions' do
      expect(api_subject.permissions).to eq []
    end

    it 'api subject with one role and permission' do
      role.permissions << permission
      api_subject.roles << role

      expect(api_subject.permissions).to eq [
        api_subject.roles.first.permissions.first.value
      ]
    end

    context 'api subjects with multiple roles and permissions' do
      before do
        rand(1..10).times do
          r = FactoryGirl.create(:role)
          rand(1..10).times do
            r.permissions << FactoryGirl.create(:permission)
          end
          api_subject.roles << r
        end
      end

      it 'api subject has multiple roles with multiple permissions' do
        res = []
        api_subject.roles.each do |result|
          result.permissions.each do |permission|
            res << permission.value
          end
        end
        expect(res).not_to be_empty
        expect(api_subject.permissions).to eq res
      end
    end
  end

  context 'api_subject#functioning?' do
    let(:api_subject) { FactoryGirl.create(:api_subject) }

    context 'api subject is functioning' do
      it 'is functioning' do
        expect(api_subject.functioning?).to eq true
      end
    end

    context 'api subject is not functioning' do
      before { api_subject.enabled = false }
      it 'is not functioning' do
        expect(api_subject.functioning?).to eq false
      end
    end
  end
end
