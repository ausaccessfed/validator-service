# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  let(:snapshot) { create :snapshot }
  let(:snapshot2) { create :snapshot }
  let(:subject) { create :subject }

  it { expect(snapshot).to be_valid }

  it '#name' do
    expect(snapshot.name).to eql "Snapshot #{snapshot.id}"
  end

  it '#taken_at' do
    expect(snapshot.taken_at).to eql snapshot.created_at.to_formatted_s(:rfc822)
  end

  describe '#latest?' do
    it 'is the latest' do
      subject.snapshots << snapshot

      expect(snapshot.latest?(subject)).to eql true
    end

    it 'is not the latest' do
      subject.snapshots = [snapshot, snapshot2]

      expect(snapshot.latest?(subject)).to eql false
    end
  end

  describe '.latest' do
    it 'has a latest' do
      subject.snapshots = [snapshot, snapshot2]

      expect(Snapshot.latest(subject)).to eql snapshot2
    end

    it 'has no latest' do
      expect(Snapshot.latest(subject)).to eql nil
    end
  end

  describe '.create_from_receiver' do
    let(:attrs) do
      Authentication::AttributeHelpers
        .federation_attributes(attributes_for(:shib_env)[:env])
    end

    before :each do
      %w(HTTP_TARGETED_ID HTTP_MAIL HTTP_DISPLAYNAME).each do |http_header|
        faa = FederationAttributeAlias.create!(
          name: http_header.sub('HTTP_', '').downcase
        )

        create(:federation_attribute,
               http_header: http_header,
               federation_attribute_aliases: [faa],
               primary_alias: faa)
      end
    end

    let(:subject) { Subject.create(attributes_for(:subject)) }
    let(:snapshot) { Snapshot.create_from_receiver(subject, attrs) }

    it 'creates a new snapshot' do
      expect { snapshot }.to change(Snapshot, :count).by(1)
    end

    it 'has the correct subject' do
      expect(snapshot.subject).to eql subject
    end

    it 'creates a new attribute value record for each attr passed in' do
      snapshot.reload.attribute_values.each do |av|
        expect(av.value)
          .to eql(attrs[av.federation_attribute.http_header])
      end
    end
  end
end
