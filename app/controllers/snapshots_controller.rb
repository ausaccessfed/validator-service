# frozen_string_literal: true
class SnapshotsController < ApplicationController
  before_action :public_action
  prepend_before_action :eager, only: [:latest, :show]

  def latest
    @snapshot = @subject.snapshots.provisioned.last

    show_actions
  end

  def index
    @snapshots = @subject.snapshots.order(id: :desc)
  end

  def show
    @snapshot = @subject.snapshots.provisioned.find(params[:id])

    show_actions
  end

  private

  def show_actions
    @attribute_values = @snapshot.attribute_values
    @categories = Category.enabled.order(:order).all

    render :show
  end

  def eager
    @subject = Subject.includes(:snapshots).find_by(id: session[:subject_id])
  end
end
