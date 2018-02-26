# frozen_string_literal: true

FactoryBot.define do
  factory :category_attribute do
    presence false
    category nil
    federation_attribute nil
  end
end
