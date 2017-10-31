# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :ensure_authenticated

  def index
    public_action
  end

  def logout
    public_action

    env['rack.session'].clear
    redirect_to('/')
  end
end
