# frozen_string_literal: true
class DashboardController < ApplicationController
  def dashboard
    public_action

    @latest_snapshot = @subject.snapshots.last
  end
end
