# frozen_string_literal: true
module FederationAttributeAdmin
  extend ActiveSupport::Concern

  # :nocov:
  # rubocop:disable Metrics/BlockLength
  included do
    rails_admin do
      object_label_method do
        :custom_label_method
      end

      label label.titleize

      list do
        field :primary_alias do
          searchable [:name]
          queryable true
          label label.titleize
        end

        field :description
      end

      show do
        field :oid do
          label label.upcase
        end

        field :primary_alias
        field :federation_attribute_aliases

        field :http_header do
          label 'HTTP Header'
        end

        field :description
        field :singular

        field :regexp
        field :regexp_triggers_failure

        field :notes_on_format
        field :notes_on_usage
        field :notes_on_privacy

        field :created_at
        field :updated_at

        fields :regexp_triggers_failure, :primary_alias,
               :federation_attribute_aliases, :notes_on_format, :notes_on_usage,
               :notes_on_privacy, :created_at, :updated_at do
          label label.titleize
        end
      end

      edit do
        field :oid do
          label label.upcase
        end

        field :internal_alias
        field :primary_alias
        field :federation_attribute_aliases

        field :http_header do
          label 'HTTP Header'
        end

        field :description
        field :singular

        field :regexp
        field :regexp_triggers_failure

        field :notes_on_format
        field :notes_on_usage
        field :notes_on_privacy

        fields :regexp_triggers_failure, :primary_alias,
               :federation_attribute_aliases, :notes_on_format, :notes_on_usage,
               :notes_on_privacy do
          label label.titleize
        end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
  # :nocov:
end
