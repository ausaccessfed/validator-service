# frozen_string_literal: true
# Class for the temporary test Controller
class TestController < ApplicationController
  skip_before_action :ensure_authenticated
  def test
    public_action
  end
end
