class Admin::UsersController < ApplicationController
  protect_from_forgery
  skip_before_action :login_required, only:[:new, :create]

  # ユーザの一覧を取得
  # @return [Array<User>] ユーザの一覧
  def index
    @users = User.includes(:tasks).page(params[:page]).per(10)
  end

  # idに対応したユーザを取得
  # user.idと紐づいたタスクを取得
  # @return [Array<Task>]
  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(5)
  end

  # ユーザのインスタンスを取得
  # @return [User]
  def new
    @user = User.new
  end

  # idに対応したユーザを取得
  # @return [User]
  def edit
    @user = User.find(params[:id])
  end

  # ユーザ登録
  # 入力情報に問題がなければ、sessionにuser.idを格納
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = 'ユーザーを登録できませんでした。'
      render 'new', status: 422
    end
  end

  # ユーザ情報の更新
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = 'ユーザー情報を更新できませんでした。'
      render 'edit', status: 422
    end
  end

  # ユーザの削除
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

  # パラメータの許可
  # return [ActionController::Parameters] 許可されたパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
