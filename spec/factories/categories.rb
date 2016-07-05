FactoryGirl.define do
  factory :category do
    name Faker::Commerce.department
    description Faker::Lorem.sentence
    url Faker::Internet.url
    enabled true
    order 1
  end
end
