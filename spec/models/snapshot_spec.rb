# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Snapshot', type: :model do
  let(:snapshot) { build :snapshot }

  it { expect(snapshot).to be_valid }

  describe '.create_from_receiver' do
    let(:attrs) { build(:shib_attrs) }
    let(:subject) { Subject.create(attributes_for(:subject)) }
    let(:snapshot) { Snapshot.create_from_receiver(subject, attrs) }

    it 'creates a new snapshot' do
      expect { snapshot }.to change(Snapshot, :count).by(1)
    end
    it 'has the correct subject' do
      expect(snapshot.subject).to eql subject
    end
  end

  describe '.update_snapshot_attribute_values' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }
    let(:update_snapshot) do
      Snapshot.update_snapshot_attribute_values(
        snapshot,
        attrs.except(:affiliation, :scoped_affiliation)
      )
    end

    it 'creates the correct number of attribute value records' do
      expect { update_snapshot }
        .to change(AttributeValue, :count).by(attrs.count - 2)
    end

    it 'creates a new attribute value record for each attr passed in' do
      update_snapshot
      snapshot.reload.attribute_values.each do |av|
        expect(av.value).to eql(attrs[av.federation_attribute.name.to_sym])
      end
    end
  end

  describe '.update_snapshot_affiliations' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }
    let(:update_snapshot) do
      Snapshot.update_snapshot_affiliations(snapshot, attrs)
    end

    it 'Creates an attribute value for each affiliation' do
      expect { update_snapshot }
        .to change(AttributeValue, :count).by(attrs[:affiliation].length)
    end

    it 'Creates attribute values for each affiliation' do
      subject_attrs = []
      update_snapshot
      snapshot.reload.attribute_values.each do |av|
        subject_attrs << av.value
      end
      expect(subject_attrs).to eql attrs[:affiliation]
    end
  end

  describe '.update_snapshot_scoped_affiliations' do
    let(:attrs) { build(:shib_attrs) }
    let(:snapshot) { create(:snapshot) }
    let(:update_snapshot) do
      Snapshot.update_snapshot_scoped_affiliations(snapshot, attrs)
    end

    it 'Creates an attribute value for each scoped_affiliation' do
      expect { update_snapshot }
        .to change(AttributeValue, :count).by(attrs[:scoped_affiliation].length)
    end

    describe do
      let(:subject_attrs) { [] }
      before do
        update_snapshot
        snapshot.reload.attribute_values.each do |av|
          subject_attrs << av.value
        end
      end

      it 'Creates attribute values for each scoped affiliation' do
        expect(subject_attrs).to eql attrs[:scoped_affiliation]
      end

      it 'should store a valid affiliation' do
        subject_attrs.each do |value|
          expect(value.match(/[a-z]{1,}@\w{1,}.\w{1,}/)).to be_truthy
        end
      end
    end
  end
end
