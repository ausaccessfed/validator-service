# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Attribute Values', type: :model do
  let(:attribute_value) { build :attribute_value }
  let(:category) { build :category }
  let(:federation_attribute) do
    create(:federation_attribute,
           regexp: '^[a-zA-Z\s\-]+$',
           regexp_triggers_failure: false,
           category_attributes: [
             CategoryAttribute.new(presence: false, category: category)
           ])
  end
  let(:strict_federation_attribute) do
    create(:federation_attribute,
           regexp: '^[a-zA-Z\s\-]+$',
           regexp_triggers_failure: true,
           category_attributes: [
             CategoryAttribute.new(presence: false, category: category)
           ])
  end
  let(:required_federation_attribute) do
    create(:federation_attribute,
           regexp: '^[a-zA-Z\s\-]+$',
           regexp_triggers_failure: false,
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

  context 'class' do
    describe '.validation_state' do
      it 'has an attribute' do
        expect(
          AttributeValue.validation_state(
            category,
            federation_attribute,
            name
          )
        ).to eql AttributeValue::ResponseFor.valid_attribute
      end

      it 'has no attribute' do
        expect(
          AttributeValue.validation_state(
            category,
            federation_attribute,
            nil
          )
        ).to eql AttributeValue::ResponseFor.not_supplied_attribute
      end
    end

    describe '.valid_response' do
      it 'is valid' do
        expect(AttributeValue.valid_response(federation_attribute, name))
          .to eql AttributeValue::ResponseFor.valid_attribute
      end

      it 'is invalid' do
        expect(
          AttributeValue.valid_response(strict_federation_attribute, '123')
        ).to eql AttributeValue::ResponseFor.invalid_attribute
      end

      it 'is imperfect' do
        expect(AttributeValue.valid_response(federation_attribute, 'Name 123'))
          .to eql AttributeValue::ResponseFor.imperfect_attribute
      end
    end

    describe '.required_response' do
      it 'is required' do
        expect(
          AttributeValue.required_response(
            category,
            required_federation_attribute
          )
        ).to eql AttributeValue::ResponseFor.required_attribute
      end

      it 'is not supplied' do
        expect(AttributeValue.required_response(category, federation_attribute))
          .to eql AttributeValue::ResponseFor.not_supplied_attribute
      end
    end
  end
end
