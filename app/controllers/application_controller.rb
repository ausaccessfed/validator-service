# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Lipstick::DynamicErrors

  protect_from_forgery with: :exception
  before_action :ensure_authenticated
  after_action :ensure_access_checked
  before_action :apply_rails_admin_csp

  # :nocov:
  def apply_rails_admin_csp
    rails_admin_controller = defined?(rails_admin_controller?) &&
                             rails_admin_controller?

    return false if !Rails.env.production? || !rails_admin_controller

    use_secure_headers_override(:rails_admin)
  end
  # :nocov:

  def subject
    subject = session[:subject_id] && Subject.find_by(id: session[:subject_id])
    return nil unless subject.try(:functioning?)
    @subject = subject
  end

  protected

  def ensure_authenticated
    return force_authentication unless session[:subject_id]

    @subject ||= Subject.find_by(id: session[:subject_id])
    raise(Unauthorized, 'Subject invalid') unless @subject
    raise(Unauthorized, 'Subject not functional') unless @subject.functioning?
  end

  def ensure_access_checked
    return if @access_checked

    method = "#{self.class.name}##{params[:action]}"
    raise("No access control performed by #{method}")
  end

  def check_access!(action)
    raise(Forbidden) unless subject.permits?(action)
    @access_checked = true
  end

  def public_action
    @access_checked = true
  end

  def force_authentication
    session[:return_url] = request.url if request.get?
    redirect_to('/auth/login')
  end
end
