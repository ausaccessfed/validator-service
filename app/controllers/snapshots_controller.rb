# frozen_string_literal: true
class SnapshotsController < ApplicationController
  before_action :public_action

  def latest
    @snapshot = @subject.snapshots.last

    show_actions
  end

  def index
    @snapshots = @subject.snapshots.order(id: :desc)
  end

  def show
    @snapshot = @subject.snapshots.find(params[:id])

    show_actions
  end

  private

  def show_actions
    @attribute_values = @snapshot.attribute_values
    @categories = Category.enabled.order(:order).all

    render :show
  end
end
