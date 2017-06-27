# frozen_string_literal: true

module SubjectAdmin
  extend ActiveSupport::Concern

  # :nocov:
  included do
    rails_admin do
      list do
        field :name

        field :persistent_id do
          label 'Federated ID'
        end
      end

      field :name
      field :mail
      field :enabled
      field :complete

      field :persistent_id do
        label 'Persistent ID'
      end

      show do
        field :snapshots

        field :created_at
        field :updated_at

        fields :created_at, :updated_at do
          label label.titleize
        end
      end
    end
  end
  # :nocov:
end
