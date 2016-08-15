# frozen_string_literal: true
FactoryGirl.define do
  factory :federation_attribute do
    # eg. oid:1.3.6.1.4.1.25178.1.2.10
    oid do
      "oid:#{Faker::Internet.ip_v4_address}" \
      ".#{Faker::Internet.ip_v4_address}"
    end
    regexp { Faker::Lorem.word }
    regexp_triggers_failure { Faker::Boolean.boolean }
    description { Faker::Lorem.paragraph }
    notes_on_format { Faker::Lorem.paragraph }
    notes_on_usage { Faker::Lorem.paragraph }
    notes_on_privacy { Faker::Lorem.paragraph }
    singular { Faker::Boolean.boolean }
    http_header { "HTTP_#{Faker::Lorem.word.upcase}" }
  end
end
