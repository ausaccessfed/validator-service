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
