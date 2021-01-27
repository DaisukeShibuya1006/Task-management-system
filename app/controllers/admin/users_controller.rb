class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = 'ユーザーを登録できませんでした。'
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = 'ユーザー情報を更新できませんでした。'
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = 'ユーザーを削除しました。'
      redirect_to admin_users_path
    else
      flash.now[:danger] = 'ユーザーを削除できませんでした。'
      redirect_to admin_users_path
    end
  end

  private

  def user_params
      params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
