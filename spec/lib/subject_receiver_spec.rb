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
        it 'has the correct identifier' do
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
      it 'updates the existing subject with the new attributes' do
        attrs[:name] = Faker::Name.name
        expect(subject_receiver.subject({}, attrs).name).to eql attrs[:name]
      end
    end

    context 'should slice the targeted_id of the subject that is created' do
      let(:result) { subject_receiver.subject({}, attrs) }
      it 'returns the correct targeted_id' do
        expect(result[:targeted_id]).to eql(attrs.slice(:targeted_id).values[0])
      end
    end
  end

  describe '#create_snapshot' do
    let(:attrs) { build(:shib_attrs) }
    let(:subject) { Subject.create(attributes_for(:subject)) }
    let(:snapshot) { subject_receiver.create_snapshot(subject, attrs) }

    it 'has the correct subject' do
      expect(snapshot.subject).to eql subject
    end
  end

  describe '#update_snapshot_attribute_values' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }
    it 'creates a new AttributeValue record for each attr passed in' do
      expect do
        subject_receiver.update_snapshot_attribute_values(
          snapshot,
          attrs.except(:affiliation, :scoped_affiliation))
      end.to change(AttributeValue, :count).by(attrs.count - 2)
    end
  end

  describe '#update_snapshot_affiliations' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }

    it 'Creates an attribute value for each affiliation' do
      expect do
        subject_receiver.update_snapshot_affiliations(
          snapshot,
          attrs)
      end.to change(AttributeValue, :count).by(attrs[:affiliation].length)
    end

    it 'Creates attribute values for each affiliation' do
      subject = subject_receiver
                .update_snapshot_affiliations(snapshot, attrs)

      subject_attrs = []

      subject.attribute_values.each do |av|
        subject_attrs << av.value
      end

      expect(subject_attrs).to eql attrs[:affiliation]
    end
  end

  describe '#update_snapshot_scoped_affiliations' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }

    it 'Creates an attribute value for each scoped_affiliation' do
      expect do
        subject_receiver.update_snapshot_scoped_affiliations(
          snapshot,
          attrs)
      end.to change(AttributeValue, :count)
        .by(attrs[:scoped_affiliation].length)
    end

    describe do
      let(:subject_attrs) { [] }
      let(:subject) do
        subject_receiver .update_snapshot_scoped_affiliations(
          snapshot,
          attrs)
      end

      before do
        subject.attribute_values.each do |av|
          subject_attrs << av.value
        end
      end

      it 'Creates attribute values for each scoped affiliation' do
        expect(subject_attrs).to eql attrs[:scoped_affiliation]
      end

      it 'should store a valid email address each scoped affiliation' do
        subject_attrs.each do |value|
          expect(value.match(/[a-z]{1,}@\w{1,}.\w{1,}/)).to be_truthy
        end
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
