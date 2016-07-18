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
            return ResponseFor.invalid_attribute
          else
            return ResponseFor.imperfect_attribute
          end
        end
      end

      ResponseFor.valid_attribute
    end

    def required_response(category, federation_attribute)
      if category.category_attributes
                 .find_by(federation_attribute: federation_attribute)
                 .try(:presence?)
        ResponseFor.required_attribute
      else
        ResponseFor.not_supplied_attribute
      end
    end
  end

  class ResponseFor
    class << self
      def required_attribute
        {
          state: 'error',
          message: 'This attribute is required for this category.',
          icon_classes: [
            'glyphicon',
            'glyphicon-remove-sign',
            'alert-danger'
          ],
          row_classes: ['danger']
        }
      end

      def invalid_attribute
        {
          state: 'invalid',
          message: 'This attribute is invalid.',
          icon_classes: [
            'glyphicon',
            'glyphicon-remove-sign',
            'alert-danger'
          ],
          row_classes: ['danger']
        }
      end

      def valid_attribute
        {
          state: 'valid',
          message: 'This attribute forefills all requirements.',
          icon_classes: [
            'glyphicon',
            'glyphicon-ok-sign',
            'alert-success'
          ],
          row_classes: ['success']
        }
      end

      def not_supplied_attribute
        {
          state: 'not_supplied',
          message: 'This attribute has not been supplied.',
          icon_classes: [
            'glyphicon',
            'glyphicon-exclamation-sign',
            'alert-warning'
          ],
          row_classes: ['warning']
        }
      end

      def imperfect_attribute
        {
          state: 'imperfect',
          message: 'This attribute is not valid, but allowable.',
          icon_classes: [
            'glyphicon',
            'glyphicon-exclamation-sign',
            'alert-warning'
          ],
          row_classes: ['warning']
        }
      end
    end
  end
end
