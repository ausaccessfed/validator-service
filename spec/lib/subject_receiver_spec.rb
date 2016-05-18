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
      name: 'shared_token',
      singular: true,
      http_header: 'HTTP_AUEDUPERSONSHAREDTOKEN')

    create(
      :federation_attribute,
      name: 'name',
      singular: true,
      http_header: 'HTTP_DISPLAYNAME')

    create(
      :federation_attribute,
      name: 'mail',
      singular: true,
      http_header: 'HTTP_MAIL')

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

  describe '#create_subject' do
    let(:attrs) { build(:shib_attrs) }

    context 'creating a new subject' do
      let(:subject) { subject_receiver.create_subject(attrs) }

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
  end

  describe '#create_snapshot' do
    let(:attrs) { build(:shib_attrs) }
    let(:subject) { Subject.create(attributes_for(:subject)) }
    let(:snapshot) { subject_receiver.create_snapshot(subject, attrs) }

    it 'creates a new snapshot' do
      expect { snapshot }.to change(Snapshot, :count).by(1)
    end
    it 'has the correct subject' do
      expect(snapshot.subject).to eql subject
    end
  end

  describe '#update_snapshot_attribute_values' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }
    let(:update_snapshot) do
      subject_receiver.update_snapshot_attribute_values(
        snapshot,
        attrs)
    end

    it 'creates the correct number of attribute value records' do
      expected_count = FederationAttribute.where(singular: true).count
      FederationAttribute.all.where(singular: false).each do |fa|
        expected_count += attrs[fa.name.to_sym].length
      end

      expect { update_snapshot }
        .to change(AttributeValue, :count).by(expected_count)
    end

    it 'creates a new attribute value for each singular attr passed in' do
      update_snapshot
      snapshot.attribute_values.each do |av|
        if av.federation_attribute.singular
          expect(av.value).to eql(attrs[av.federation_attribute.name.to_sym])
        end
      end
    end

    it 'creates a new attribute value for each multi_value attr passed in' do
      update_snapshot
      FederationAttribute.where(singular: false).each do |fa|
        fa.attribute_values.each do |av|
          expect(attrs[fa.name.to_sym]).to include(av.value)
        end
      end
    end
  end

  describe '#map_attributes' do
    let(:attrs) { build(:shib_attrs) }
    let(:env) { {} }
    before do
      env['HTTP_TARGETED_ID'] = attrs[:targeted_id]
      env['HTTP_AUEDUPERSONSHAREDTOKEN'] = attrs[:shared_token]
      env['HTTP_DISPLAYNAME'] = attrs[:display_name]
      env['HTTP_MAIL'] = attrs[:mail]
      env['HTTP_EDUPERSONAFFILIATION'] = 'abc;def'
      env['HTTP_EDUPERSONSCOPEDAFFILIATION'] = 'abc;def'
    end

    it 'returns a hash of attributes' do
      expect(subject_receiver.map_attributes(env)).to eql(
        targeted_id: env['HTTP_TARGETED_ID'],
        shared_token: env['HTTP_AUEDUPERSONSHAREDTOKEN'],
        name: env['HTTP_DISPLAYNAME'],
        mail: env['HTTP_MAIL'],
        affiliation: %w(abc def),
        scoped_affiliation: %w(abc def))
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }
    it 'redirects to the dashboard page after a successful login' do
      expect(result).to eql([302, { 'Location' => '/dashboard' }, []])
    end
  end
end
