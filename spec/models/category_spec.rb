# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }

  describe '#validation_order' do
    let(:federation_attributes) { [:targeted_id, :mail, :displayname] }

    before :each do
      create_federation_attributes(federation_attributes)

      FederationAttribute.all.each do |fa|
        ca = CategoryAttribute.new
        ca.category = category
        ca.federation_attribute = fa
        ca.presence = true
        ca.save!
      end
    end

    let(:first_attribute) { FederationAttribute.all.first }
    let(:second_attribute) { FederationAttribute.all.second }

    let(:first_attribute_value) do
      create(:attribute_value, federation_attribute: first_attribute)
    end

    let(:second_attribute_value) do
      create(:attribute_value, federation_attribute: second_attribute)
    end

    let(:attribute_values) { [first_attribute_value, second_attribute_value] }

    it 'groups by validation state and sorts by name' do
      result = category.validation_order(attribute_values)

      expect(result.size).to(eql 2)

      expect(result.first).to(
        eql(
          [
            ApplicationHelper::ResponseFor.required_attribute,
            [
              [FederationAttribute.find_by(internal_alias: 'displayname'), nil]
            ]
          ]
        )
      )

      expect(result.second).to(
        eql(
          [
            ApplicationHelper::ResponseFor.valid_attribute,
            [
              [second_attribute, second_attribute_value.value],
              [first_attribute, first_attribute_value.value]
            ]
          ]
        )
      )
    end
  end
end
