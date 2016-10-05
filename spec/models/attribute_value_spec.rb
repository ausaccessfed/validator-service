# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AttributeValue, type: :model do
  let(:attribute_value) do
    create(
      :attribute_value,
      federation_attribute: federation_attribute
    )
  end

  let(:category) { create :category }

  let(:federation_attribute_alias) { create :federation_attribute_alias }

  let(:federation_attribute) do
    create(:federation_attribute,
           regexp: '^[a-zA-Z\s\-\.\\\']+$',
           regexp_triggers_failure: false,
           federation_attribute_aliases: [federation_attribute_alias],
           primary_alias_id: federation_attribute_alias.id,
           category_attributes: [
             CategoryAttribute.new(presence: false, category: category)
           ])
  end

  let(:strict_federation_attribute) do
    create(:federation_attribute,
           regexp: '^[a-zA-Z\s\-\.\\\']+$',
           regexp_triggers_failure: true,
           federation_attribute_aliases: [federation_attribute_alias],
           primary_alias_id: federation_attribute_alias.id,
           category_attributes: [
             CategoryAttribute.new(presence: false, category: category)
           ])
  end

  let(:required_federation_attribute) do
    create(:federation_attribute,
           regexp: '^[a-zA-Z\s\-\.\\\']+$',
           regexp_triggers_failure: false,
           federation_attribute_aliases: [federation_attribute_alias],
           primary_alias_id: federation_attribute_alias.id,
           category_attributes: [
             CategoryAttribute.new(presence: true, category: category)
           ])
  end

  let(:name) { Faker::Name.name }

  it { expect(attribute_value).to be_valid }

  it 'is invalid without a value' do
    attribute_value.value = nil
    expect(attribute_value).not_to be_valid
  end

  it '#name' do
    expect(attribute_value.name).to eql federation_attribute.name
  end

  it '#custom_label_method' do
    expect(attribute_value.custom_label_method).to(
      eql "#{federation_attribute.primary_alias.name}: #{attribute_value.value}"
    )
  end

  context 'class' do
    describe '.validation_state' do
      it 'has an attribute' do
        expect(
          AttributeValue.validation_state(
            category,
            federation_attribute,
            name
          )
        ).to eql ApplicationHelper::ResponseFor.valid_attribute
      end

      it 'has no attribute' do
        expect(
          AttributeValue.validation_state(
            category,
            federation_attribute,
            nil
          )
        ).to eql ApplicationHelper::ResponseFor.not_supplied_attribute
      end
    end

    describe '.valid_response' do
      it 'is valid' do
        expect(AttributeValue.valid_response(federation_attribute, name))
          .to eql ApplicationHelper::ResponseFor.valid_attribute
      end

      it 'is invalid' do
        expect(
          AttributeValue.valid_response(strict_federation_attribute, '123')
        ).to eql ApplicationHelper::ResponseFor.invalid_attribute
      end

      it 'is imperfect' do
        expect(AttributeValue.valid_response(federation_attribute, 'Name 123'))
          .to eql ApplicationHelper::ResponseFor.imperfect_attribute
      end
    end

    describe '.required_response' do
      it 'is required' do
        expect(
          AttributeValue.required_response(
            category,
            required_federation_attribute
          )
        ).to eql ApplicationHelper::ResponseFor.required_attribute
      end

      it 'is not supplied' do
        expect(AttributeValue.required_response(category, federation_attribute))
          .to eql ApplicationHelper::ResponseFor.not_supplied_attribute
      end
    end
  end
end
