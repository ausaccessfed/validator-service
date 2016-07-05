# frozen_string_literal: true
class DashboardController < ApplicationController
  def dashboard
    public_action

    @latest_snapshot = @subject.snapshots.last
    @snapshot_values = @latest_snapshot.attribute_values

    @categories = Category.order(:order).all
  end
end
