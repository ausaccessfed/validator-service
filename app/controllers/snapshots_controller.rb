# frozen_string_literal: true
class SnapshotsController < ApplicationController
  def latest
    public_action

    @latest_snapshot = @subject.snapshots.last
    @snapshot_values = @latest_snapshot.attribute_values

    @categories = Category.enabled.order(:order).all

    render :show
  end
end
