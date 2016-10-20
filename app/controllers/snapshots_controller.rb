# frozen_string_literal: true
class SnapshotsController < ApplicationController
  before_action :public_action
  prepend_before_action :eager, only: [:latest, :show]

  def latest
    @snapshot = @snapshot_scope.last

    show_actions
  end

  def index
    @snapshots = @subject.snapshots.order(id: :desc)
  end

  def show
    @snapshot = @snapshot_scope.find(params[:id])

    @admin_viewer = @subject != @snapshot.subject

    show_actions
  end

  private

  def show_actions
    @attribute_values = @snapshot.attribute_values
    @categories = Category.enabled.order(:order).all

    render :show
  end

  def eager
    if subject
      if subject.permits?('app:validator:admin:web_interface')
        @subject = subject
        @snapshot_scope = Snapshot.provisioned
      else
        @subject = Subject.includes(:snapshots).find_by(id: session[:subject_id])
        @snapshot_scope = @subject.snapshots.provisioned
      end
    end
  end
end
