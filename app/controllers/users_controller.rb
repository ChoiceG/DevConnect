class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user_or_admin, only: [ :show ]

  def index
    @users = User.joins(:profile).where.not(profiles: { avatar: nil }).where.not(profiles: { avatar: "" })
    @users = User.includes(:profile)
  end

  # GET request to /users/:id
  def show
    @user = User.find(params[:id])
    @profile = @user.profile # or wherever the profile is attached to user
  end

  private
  def only_current_user_or_admin
    @user = User.find(params[:id])
    # redirect_to root_path unless @user == current_user
    # Allow the current user or an admin to view the profile
    unless current_user.admin? || @user == current_user
      redirect_to root_path, alert: "You can only view users profile from the community page!"
    end
  end
end
