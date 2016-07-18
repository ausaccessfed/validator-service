# frozen_string_literal: true
class AttributeValue < ActiveRecord::Base
  has_many :snapshot_attribute_values
  has_one :snapshot, through: :snapshot_attribute_values

  belongs_to :federation_attribute

  valhammer

  class << self
    def validation_state(category, federation_attribute, attribute_value)
      if attribute_value
        valid_response(federation_attribute, attribute_value)
      else
        required_response(category, federation_attribute)
      end
    end

    def valid_response(federation_attribute, attribute_value)
      if federation_attribute.regexp
        unless Regexp.new(federation_attribute.regexp).match(attribute_value)
          if federation_attribute.regexp_triggers_failure?
            return ApplicationHelper::ResponseFor.invalid_attribute
          else
            return ApplicationHelper::ResponseFor.imperfect_attribute
          end
        end
      end

      ApplicationHelper::ResponseFor.valid_attribute
    end

    def required_response(category, federation_attribute)
      if category.category_attributes
                 .find_by(federation_attribute: federation_attribute)
                 .try(:presence?)
        ApplicationHelper::ResponseFor.required_attribute
      else
        ApplicationHelper::ResponseFor.not_supplied_attribute
      end
    end
  end
end
