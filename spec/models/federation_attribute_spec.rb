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

  context 'scopes' do
    it '.alias_lookup' do
      faa = federation_attribute.federation_attribute_aliases.first.name

      expect(FederationAttribute.alias_lookup(faa).first).to(
        eql federation_attribute
      )
    end

    it '.fuzzy_lookup' do
      oid = federation_attribute.oid

      expect(FederationAttribute.fuzzy_lookup(oid).first).to(
        eql federation_attribute
      )

      faa = federation_attribute.federation_attribute_aliases.first.name

      expect(FederationAttribute.fuzzy_lookup(faa).first).to(
        eql federation_attribute
      )
    end

    it '.name_ordered' do
      a = :targeted_id
      b = :mail
      c = :displayname

      create_federation_attributes([a, b, c])

      expect(FederationAttribute.name_ordered.to_a).to(
        eql [
          FederationAttribute.find_by(internal_alias: c),
          FederationAttribute.find_by(internal_alias: b),
          FederationAttribute.find_by(internal_alias: a)
        ]
      )
    end
  end

  describe '#primary_alias_name' do
    it 'uses a primary alias' do
      expect(federation_attribute.primary_alias_name).to eql(
        federation_attribute_alias.name
      )
    end
  end

  describe '#custom_label_method' do
    it 'uses internal_alias and oid' do
      expect(federation_attribute.custom_label_method).to eql(
        federation_attribute_alias.name
      )
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
               'HTTP_SCOPED_AFFILIATION' =>
                 shib_env['HTTP_SCOPED_AFFILIATION'])
    end

    let(:has_existing_attributes) do
      create_federation_attributes(
        only_existing_attributes.keys.map do |http_header|
          http_header.sub(/^HTTP_/, '').downcase.to_sym
        end
      )
    end

    describe '.existing_headers' do
      it 'grabs headers from the db' do
        has_existing_attributes

        expect(subject.existing_headers).to eq(%w[
                                                 HTTP_CN
                                                 HTTP_DISPLAYNAME
                                                 HTTP_O
                                               ])
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
          %w[HTTP_HOMEORGANIZATIONTYPE HTTP_SCOPED_AFFILIATION]
        )
      end

      it 'has no new attributes' do
        has_existing_attributes

        expect(subject.new_attributes(only_existing_attributes).keys).to eql([])
      end
    end
  end
end
