class AdminHubController < ApplicationController
  def index
    @users = User.all.order("created_at DESC")
  end

  def toggle_admin
    @user = User.find_by(id: params[:id])
    if current_user.id != @user.id && !@user.master?
      @user.toggle!(:admin)
    end
    redirect_to admin_hub_index_path
  end
end