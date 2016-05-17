# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }
  before do
    create(
      :federation_attribute,
      name: 'targeted_id',
      singular: true,
      http_header: 'HTTP_TARGETED_ID')

    create(
      :federation_attribute,
      name: 'affiliation',
      singular: false,
      http_header: 'HTTP_EDUPERSONAFFILIATION')

    create(
      :federation_attribute,
      name: 'scoped_affiliation',
      singular: false,
      http_header: 'HTTP_EDUPERSONSCOPEDAFFILIATION')
  end

  # describe '#subject' do
  #   let(:attrs) { build(:shib_attrs) }
  #
  #   context 'creating subject and associated records' do
  #     let(:subject) { subject_receiver.subject({}, attrs) }
  #
  #     it 'persists a subject record' do
  #       expect(subject).to be_persisted
  #     end
  #
  #     describe 'create a subject record with the correct attributes' do
  #       it 'has the correct targeted_id' do
  #         expect(subject.targeted_id).to eql attrs[:targeted_id]
  #       end
  #       it 'has the correct name' do
  #         expect(subject.name).to eql attrs[:name]
  #       end
  #       it 'has the correct email' do
  #         expect(subject.mail).to eql attrs[:mail]
  #       end
  #       it 'is enabled' do
  #         expect(subject.enabled).to eql true
  #       end
  #       it 'is complete' do
  #         expect(subject.complete).to eql true
  #       end
  #     end
  #   end
  #
  #   context 'updates an existing subject' do
  #     let(:subject) { Subject.create(attributes_for(:subject)) }
  #     it 'does not create a new subject if one already exists' do
  #       attrs = build(:shib_attrs)
  #       attrs[:targeted_id] = subject.targeted_id
  #       expect { subject_receiver.subject({}, attrs) }
  #         .to change(Subject, :count).by(0)
  #     end
  #     it 'updates the existing subject with the new name attributes' do
  #       attrs[:name] = Faker::Name.name
  #       expect(subject_receiver.subject({}, attrs).name).to eql attrs[:name]
  #     end
  #     it 'updates the existing subject with the new mail attributes' do
  #       attrs[:mail] = Faker::Internet.email
  #       expect(subject_receiver.subject({}, attrs).mail).to eql attrs[:mail]
  #     end
  #   end
  # end

  # describe '#create_snapshot' do
  #   let(:attrs) { build(:shib_attrs) }
  #   let(:subject) { Subject.create(attributes_for(:subject)) }
  #   let(:snapshot) { subject_receiver.create_snapshot(subject, attrs) }
  #
  #   it 'creates a new snapshot' do
  #     expect { snapshot }.to change(Snapshot, :count).by(1)
  #   end
  #   it 'has the correct subject' do
  #     expect(snapshot.subject).to eql subject
  #   end
  # end
  #
  # describe '#update_snapshot_attribute_values' do
  #   let(:attrs) { build(:shib_attrs) }
  #   let(:snapshot) { create(:snapshot) }
  #   let(:update_snapshot) do
  #     subject_receiver.update_snapshot_attribute_values(
  #       snapshot,
  #       attrs.except(:affiliation, :scoped_affiliation))
  #   end
  #
  #   it 'creates the correct number of attribute value records' do
  #     expect { update_snapshot }
  #       .to change(AttributeValue, :count).by(attrs.count - 2)
  #   end
  #
  #   it 'creates a new attribute value record for each attr passed in' do
  #     update_snapshot
  #     snapshot.reload.attribute_values.each do |av|
  #       expect(av.value).to eql(attrs[av.federation_attribute.name.to_sym])
  #     end
  #   end
  # end

  describe '#map_attributes' do
    let(:env) { {} }
    before do
      env['HTTP_TARGETED_ID'] = 'abc'
      env['HTTP_EDUPERSONAFFILIATION'] = 'abc;def'
      env['HTTP_EDUPERSONSCOPEDAFFILIATION'] = 'abc;def'
    end

    it 'returns a hash of attributes' do
      expect(subject_receiver.map_attributes(env)).to eql({:targeted_id=>"abc", :affiliation=>["abc", "def"], :scoped_affiliation=>["abc", "def"]})
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }
    it 'redirects to the dashboard page after a successful login' do
      expect(result).to eql([302, { 'Location' => '/dashboard' }, []])
    end
  end
end
