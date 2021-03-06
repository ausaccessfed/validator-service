# frozen_string_literal: true

class DocumentationController < ApplicationController
  skip_before_action :ensure_authenticated

  before_action :public_action, :subject

  def index; end
end
