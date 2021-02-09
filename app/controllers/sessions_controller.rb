class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :login_required

  def new; end


  # ログイン
  # emailとpasswordが一致していたら、sessionにuser.idを格納
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

  # ログアウト
  # 全てのセッション情報を削除
  def destroy
    reset_session
    flash[:success] = 'ログアウトしました'
    redirect_to login_path
  end

  private

  # パラメータの認証
  # @return[ActionController::Parameters] 許可されたパラメータ
  def session_params
    params.require(:session).permit(:email, :password)
  end
end

