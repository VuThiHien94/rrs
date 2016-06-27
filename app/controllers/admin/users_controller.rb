class Admin::UsersController < ApplicationController
  before_action :logged_as_admin, only: [:index, :destroy]
  def index
    @users = User.all
  end

  def destroy
    @user = User.find_by id: params[:id]
    if @user && @user.destroy
      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.user")
    else
      flash[:danger] = t "controllers.flash.common.destroy_error",
        objects: t("activerecord.model.user")
    end
    redirect_to admin_users_url
  end
end
