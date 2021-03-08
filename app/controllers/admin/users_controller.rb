class Admin::UsersController < ApplicationController
  protect_from_forgery
  before_action :require_admin

  # ユーザ一覧を取得
  # @return [Array<User>] ユーザ一覧
  def index
    @users = User.includes(:tasks).page(params[:page]).per(10)
  end

  # ユーザ詳細画面を取得
  # user.idと紐づいたタスクを取得
  # @return [Array<Task>]
  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(5)
  end

  # ユーザ新規作成画面を取得
  # @return [User]
  def new
    @user = User.new
  end

  # ユーザ編集画面を取得
  # @return [User]
  def edit
    @user = User.find(params[:id])
  end

  # ユーザ登録
  # 入力情報に問題がなければ、sessionにuser.idを格納
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = 'ユーザを登録できませんでした。'
      render 'new', status: 422
    end
  end

  # ユーザ情報の更新
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'ユーザ情報を更新しました。'
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = 'ユーザ情報を更新できませんでした。'
      render 'edit', status: 422
    end
  end

  # ユーザ削除
  def destroy
    @user = User.find(params[:id])
    if current_user.id == @user.id
      flash[:warning] = '自分自身を削除することはできません。'
      redirect_to admin_user_url(@user)
      return
    end
    if @user.destroy
      flash[:success] = 'ユーザを削除しました。'
      redirect_to admin_users_path
    else
      flash[:danger] = 'ユーザを削除できませんでした。'
      redirect_to admin_user_url(@user)
    end
  end

  private

  # パラメータの許可
  # return [ActionController::Parameters] 許可されたパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :is_admin, :password, :password_confirmation)
  end

  # 管理者権限がないとき、例外処理を発生
  def require_admin
    raise Forbidden unless current_user.is_admin?
  end
end
