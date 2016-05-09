# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Authentication::SubjectReceiver do
  let(:subject_receiver) { Authentication::SubjectReceiver.new }

  describe '#subject' do
    let(:attrs) { attributes_for(:subject, :receiver_attrs) }

    context 'creating subject' do
      it 'creates a new subject based on attrs' do
        expect { subject_receiver.subject({}, attrs) }
          .to change(Subject, :count).by(1)
      end
    end

    context 'updates an existing subject' do
      before { @sub = Subject.create(attributes_for(:subject)) }

      it 'does not create a new subject if one already exists' do
        attrs = attributes_for(:subject, :receiver_attrs)
        attrs[:targeted_id] = @sub.targeted_id

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

  describe '#update_snapshot_attribute_values' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { FactoryGirl.create(:snapshot) }
    it 'creates a new AttributeValue record for each attr passed in' do
      expect do
        subject_receiver.update_snapshot_attribute_values(
          snapshot,
          attrs.except(:affiliation, :scoped_affiliation))
      end.to change(AttributeValue, :count).by(attrs.count - 2)
    end
  end

  describe '#finish' do
    let(:result) { subject_receiver.finish({}) }
    it 'redirects to the dashboard page after a successful login' do
      expect(result).to eql([302, { 'Location' => '/dashboard' }, []])
    end
  end
end
