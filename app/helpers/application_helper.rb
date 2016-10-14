# frozen_string_literal: true
module ApplicationHelper
  include Lipstick::Helpers::LayoutHelper
  include Lipstick::Helpers::NavHelper

  def application_version
    ValidatorService::Application::VERSION
  end

  class ResponseFor
    class << self
      def required_attribute
        {
          state: 'error',
          order: 1,
          message: 'This attribute is required for this category.',
          icon_classes: [
            'glyphicon',
            'glyphicon-remove-sign',
            'validator-error'
          ]
        }
      end

      def invalid_attribute
        {
          state: 'invalid',
          order: 2,
          message: 'This attribute is invalid.',
          icon_classes: [
            'glyphicon',
            'glyphicon-remove-sign',
            'validator-error'
          ]
        }
      end

      def valid_attribute
        {
          state: 'valid',
          order: 4,
          message: 'This attribute fulfils all requirements.',
          icon_classes: [
            'glyphicon',
            'glyphicon-ok-sign',
            'validator-success'
          ]
        }
      end

      def not_supplied_attribute
        {
          state: 'not_supplied',
          order: 5,
          message: 'This attribute has not been supplied.',
          icon_classes: [
            'glyphicon',
            'glyphicon-exclamation-sign',
            'validator-warning'
          ]
        }
      end

      def imperfect_attribute
        {
          state: 'imperfect',
          order: 3,
          message: 'This attribute is not valid, but allowable.',
          icon_classes: [
            'glyphicon',
            'glyphicon-exclamation-sign',
            'validator-warning'
          ]
        }
      end
    end
  end
end
