# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Federation Attributes', type: :model do
  let(:federation_attribute) { build :federation_attribute }

  it { expect(federation_attribute).to be_valid }

  it 'is invalid without a name' do
    federation_attribute.name = nil
    expect(federation_attribute).not_to be_valid
  end

  it 'is invalid without a regexp_triggers_failure value' do
    federation_attribute.regexp_triggers_failure = nil
    expect(federation_attribute).not_to be_valid
  end

  it 'is invalid without a singular value' do
    federation_attribute.singular = nil
    expect(federation_attribute).not_to be_valid
  end

  context 'class' do
    subject { FederationAttribute }

    let(:shib_env) { attributes_for(:shib_env)[:env] }

    let(:only_existing_attributes) do
      {
        'HTTP_DISPLAYNAME' => 'Display Name',
        'HTTP_O' => 'Organisation Name',
        'HTTP_CN' => 'Common Name'
      }
    end

    let(:with_new_attributes) do
      only_existing_attributes
        .merge('HTTP_HOMEORGANIZATIONTYPE' => 'Home Organisation Type',
               'HTTP_EDUPERSONSCOPEDAFFILIATION' => 'Edu Person Affiliation')
    end

    let(:has_existing_attributes) do
      only_existing_attributes.each do |http_header, _value|
        create(:federation_attribute, http_header: http_header)
      end
    end

    describe '.existing_headers' do
      it 'grabs headers from the db' do
        has_existing_attributes

        expect(subject.existing_headers).to eq(%w(
                                                 HTTP_DISPLAYNAME
                                                 HTTP_O
                                                 HTTP_CN
                                               ))
      end
    end

    describe '.existing_attributes' do
      it 'finds only those known' do
        has_existing_attributes

        expect(subject.existing_attributes(shib_env))
          .to eql('HTTP_CN' => 'Jefferey Kohler',
                  'HTTP_DISPLAYNAME' => 'Jefferey Kohler',
                  'HTTP_O' => 'Southern Ernser University')
      end

      it 'finds none' do
        expect(subject.existing_attributes(shib_env)).to eql({})
      end
    end

    describe '.new_attributes?' do
      it 'has new attributes' do
        has_existing_attributes

        expect(subject.new_attributes?(with_new_attributes.keys))
          .to eql true
      end

      it 'has no new attributes' do
        has_existing_attributes

        expect(subject.new_attributes?(only_existing_attributes.keys))
          .to eql false
      end
    end

    describe '.new_attributes' do
      it 'has new attributes' do
        has_existing_attributes

        expect(subject.new_attributes(with_new_attributes).keys).to eql(
          %w(HTTP_HOMEORGANIZATIONTYPE HTTP_EDUPERSONSCOPEDAFFILIATION)
        )
      end

      it 'has no new attributes' do
        has_existing_attributes

        expect(subject.new_attributes(only_existing_attributes).keys).to eql([])
      end
    end
  end
end
