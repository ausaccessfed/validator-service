# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FederationAttribute, type: :model do
  let(:federation_attribute_alias) { create :federation_attribute_alias }
  let(:federation_attribute) do
    create :federation_attribute,
           federation_attribute_aliases: [federation_attribute_alias],
           primary_alias: federation_attribute_alias
  end

  it { expect(federation_attribute).to be_valid }

  describe '#name' do
    it 'uses a primary alias' do
      expect(federation_attribute.name).to eql(federation_attribute_alias.name)
    end
  end

  describe '#aliases' do
    it 'no aliases' do
      expect(federation_attribute.aliases.to_a).to eql([])
    end

    it 'aliases' do
      a = create :federation_attribute_alias
      federation_attribute.federation_attribute_aliases << a

      expect(federation_attribute.aliases.to_a).to eql([a])
    end
  end

  context 'class' do
    subject { FederationAttribute }

    let(:shib_env) { attributes_for(:shib_env)[:env] }

    let(:only_existing_attributes) do
      {
        'HTTP_DISPLAYNAME' => shib_env['HTTP_DISPLAYNAME'],
        'HTTP_O' => shib_env['HTTP_O'],
        'HTTP_CN' => shib_env['HTTP_CN']
      }
    end

    let(:with_new_attributes) do
      only_existing_attributes
        .merge('HTTP_HOMEORGANIZATIONTYPE' =>
                 shib_env['HTTP_HOMEORGANIZATIONTYPE'],
               'HTTP_EDUPERSONSCOPEDAFFILIATION' =>
                 shib_env['HTTP_EDUPERSONAFFILIATION'])
    end

    let(:has_existing_attributes) do
      only_existing_attributes.each do |http_header, _value|
        faa = FederationAttributeAlias.create!(
          name: http_header.sub('HTTP_', '').downcase
        )

        create(:federation_attribute,
               http_header: http_header,
               federation_attribute_aliases: [faa],
               primary_alias: faa)
      end
    end

    describe '.existing_headers' do
      it 'grabs headers from the db' do
        has_existing_attributes

        expect(subject.existing_headers).to eq(%w(
                                                 HTTP_CN
                                                 HTTP_DISPLAYNAME
                                                 HTTP_O
                                               ))
      end
    end

    describe '.existing_attributes' do
      it 'finds only those known' do
        has_existing_attributes

        expect(subject.existing_attributes(shib_env))
          .to eql('HTTP_CN' => shib_env['HTTP_CN'],
                  'HTTP_DISPLAYNAME' => shib_env['HTTP_DISPLAYNAME'],
                  'HTTP_O' => shib_env['HTTP_O'])
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