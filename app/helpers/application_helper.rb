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
            'validator-error'
          ],
          row_classes: []
        }
      end

      def invalid_attribute
        {
          state: 'invalid',
          message: 'This attribute is invalid.',
          icon_classes: [
            'glyphicon',
            'glyphicon-remove-sign',
            'validator-error'
          ],
          row_classes: []
        }
      end

      def valid_attribute
        {
          state: 'valid',
          message: 'This attribute forefills all requirements.',
          icon_classes: [
            'glyphicon',
            'glyphicon-ok-sign',
            'validator-success'
          ],
          row_classes: []
        }
      end

      def not_supplied_attribute
        {
          state: 'not_supplied',
          message: 'This attribute has not been supplied.',
          icon_classes: [
            'glyphicon',
            'glyphicon-exclamation-sign',
            'validator-warning'
          ],
          row_classes: []
        }
      end

      def imperfect_attribute
        {
          state: 'imperfect',
          message: 'This attribute is not valid, but allowable.',
          icon_classes: [
            'glyphicon',
            'glyphicon-exclamation-sign',
            'validator-warning'
          ],
          row_classes: []
        }
      end
    end
  end
end
