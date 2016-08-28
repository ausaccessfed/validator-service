# frozen_string_literal: true
class Role < ApplicationRecord
  has_many :api_subject_roles
  has_many :api_subjects, through: :api_subject_roles

  has_many :subject_roles
  has_many :subjects, through: :subject_roles

  has_many :permissions

  valhammer

  def self.for_entitlement(entitlement)
    create_with(name: 'auto').find_or_create_by!(entitlement: entitlement)
                             .tap(&:update_permissions)
  end

  def update_permissions
    return update_admin_permissions if admin_entitlements?

    permissions.destroy_all
  end

  def admin_entitlements?
    return unless config[:admin_entitlements]

    config[:admin_entitlements].include? entitlement
  end

  private

  def update_admin_permissions
    ensure_permission_values('*')
  end

  def ensure_permission_values(values)
    Array(values).each { |v| permissions.find_or_create_by!(value: v) }
    permissions.where.not(value: values).destroy_all
  end

  def config
    Rails.application.config.validator_service.ide
  end
end
