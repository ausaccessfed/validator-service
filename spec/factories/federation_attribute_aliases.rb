# frozen_string_literal: true

FactoryBot.define do
  factory :federation_attribute_alias do
    name { "#{Faker::Lorem.word} #{Time.now.to_i}" }
  end
end
