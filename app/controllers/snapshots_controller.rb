# frozen_string_literal: true
class SnapshotsController < ApplicationController
  before_action :public_action

  def latest
    eager_load


    show_actions
  end

  def index
    @snapshots = @subject.snapshots.order(id: :desc)
  end

  def show
    eager_load

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

  def eager_load
    if subject.permits?('app:validator:admin:web_interface')
      @snapshot_scope = Snapshot.provisioned
    else
      @subject = Subject.includes(:snapshots).find_by(id: session[:subject_id])
      @snapshot_scope = @subject.snapshots.provisioned
    end
  end
end
