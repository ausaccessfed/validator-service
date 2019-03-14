# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }

  let(:federation_attributes) { %i[targeted_id mail o displayname] }

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
  let(:third_attribute) { FederationAttribute.all.third }
  let(:fourth_attribute) { FederationAttribute.all.fourth }

  let(:first_attribute_value) do
    create(:attribute_value, federation_attribute: first_attribute)
  end

  let(:second_attribute_value) do
    create(:attribute_value, federation_attribute: first_attribute)
  end

  let(:third_attribute_value) do
    create(:attribute_value, federation_attribute: second_attribute)
  end

  let(:attribute_values) do
    [
      first_attribute_value,
      second_attribute_value,
      third_attribute_value
    ]
  end

  describe '#validation_order' do
    it 'orders by validation state' do
      expect(category).to(
        receive(:grouped_attributes).with(attribute_values).and_return(
          [
            [
              ApplicationHelper::ResponseFor.valid_attribute,
              [
                [second_attribute, [third_attribute_value.value]],
                [
                  first_attribute,
                  [
                    first_attribute_value.value,
                    second_attribute_value.value
                  ]
                ]
              ]
            ],
            [
              ApplicationHelper::ResponseFor.required_attribute,
              [
                [
                  FederationAttribute.find_by(internal_alias: 'displayname'),
                  [nil]
                ]
              ]
            ]
          ]
        )
      )

      expect(category.validation_order(attribute_values)).to eql(
        [
          [
            ApplicationHelper::ResponseFor.required_attribute,
            [
              [
                FederationAttribute.find_by(internal_alias: 'displayname'),
                [nil]
              ]
            ]
          ],
          [
            ApplicationHelper::ResponseFor.valid_attribute,
            [
              [second_attribute, [third_attribute_value.value]],
              [
                first_attribute,
                [
                  first_attribute_value.value,
                  second_attribute_value.value
                ]
              ]
            ]
          ]
        ]
      )
    end
  end

  describe '#matched_attributes' do
    it 'matches federation attributes to their attribute values' do
      expect(category.matched_attributes(attribute_values)).to(
        eql(
          [
            [fourth_attribute, [nil]],
            [second_attribute, [third_attribute_value.value]],
            [third_attribute, [nil]],
            [
              first_attribute,
              [
                first_attribute_value.value,
                second_attribute_value.value
              ]
            ]
          ]
        )
      )
    end
  end

  describe '#grouped_attributes' do
    it 'groups for single attribute values' do
      expect(category.grouped_attributes(attribute_values)).to(
        eql(
          [
            [
              ApplicationHelper::ResponseFor.required_attribute,
              [
                [
                  FederationAttribute.find_by(internal_alias: 'displayname'),
                  [nil]
                ],
                [
                  FederationAttribute.find_by(internal_alias: 'o'),
                  [nil]
                ]
              ]
            ],
            [
              ApplicationHelper::ResponseFor.valid_attribute,
              [
                [second_attribute, [third_attribute_value.value]],
                [
                  first_attribute,
                  [
                    first_attribute_value.value,
                    second_attribute_value.value
                  ]
                ]
              ]
            ]
          ]
        )
      )
    end

    it 'groups for multi-value attributes, taking order into consideration' do
      fa = FederationAttribute.find_by(internal_alias: 'targeted_id')
      fa.update(
        regexp: '[a-zA-Z]+',
        regexp_triggers_failure: false
      )
      second_attribute_value.update!(value: 123)

      expect(category.grouped_attributes(attribute_values)).to(
        eql(
          [
            [
              ApplicationHelper::ResponseFor.required_attribute,
              [
                [
                  FederationAttribute.find_by(internal_alias: 'displayname'),
                  [nil]
                ],
                [
                  FederationAttribute.find_by(internal_alias: 'o'),
                  [nil]
                ]
              ]
            ],
            [
              ApplicationHelper::ResponseFor.valid_attribute,
              [
                [second_attribute, [third_attribute_value.value]]
              ]
            ],
            [
              ApplicationHelper::ResponseFor.imperfect_attribute,
              [
                [
                  first_attribute,
                  [
                    first_attribute_value.value,
                    second_attribute_value.value
                  ]
                ]
              ]
            ]
          ]
        )
      )
    end
  end
end
