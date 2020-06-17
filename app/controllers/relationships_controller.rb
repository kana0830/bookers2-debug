class RelationshipsController < ApplicationController
  # before_action :set_user

  def create
    @user = User.find(params[:follow_id])
    following = current_user.follow(@user)
    following.save
    flash[:notice] = "ユーザーをフォローしました"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user = User.find(params[:follow_id])
    following = current_user.unfollow(@user)
    following.destroy
    flash[:notice] = "ユーザーのフォローを解除しました"
    redirect_back(fallback_location: root_path)
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers
  end

end
