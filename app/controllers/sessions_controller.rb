class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :login_required

  def new; end

  # ユーザがログインする
  # 登録済みのemailであれば、パスワードの確認を行う
  # @return[Object] ユーザがログイン
  def create
    @user = User.find_by(email: session_params[:email])
    if @user&.authenticate(session_params[:password])
      session[:user_id] = @user.id
      flash[:success] = 'ログインしました'
      redirect_to root_path
    else
      flash.now[:danger] = 'ログインに失敗しました。メールアドレスとパスワードを確認してください。'
      render 'new', status: 401
    end
  end

  # ユーザがログアウトする
  # @return[Object] ユーザがログアウト
  def destroy
    reset_session
    flash[:success] = 'ログアウトしました'
    redirect_to login_path
  end

  private

  # 許可されたパラメータのみ通過させる
  # @param[Hash] 許可されたパラメータのみ通過
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
