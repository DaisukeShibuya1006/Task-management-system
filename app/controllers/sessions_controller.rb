class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :login_required

  def new; end


  # 入力されたemailがUserモデル内のemailと一致するかを確認
  # emailが一致する場合は、passwordが一致するかを判定
  # emailが一致しない場合は、ログイン失敗
  # emailとpasswordが一致する場合はsessionにuser.idを格納
  # @return[User]ログイン

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

  # 全てのセッション情報を削除
  # ログアウト
  def destroy
    reset_session
    flash[:success] = 'ログアウトしました'
    redirect_to login_path
  end

  private

  # 許可されたパラメータのみ通過
  # @param email[String] 許可されたemail
  # @param password[String] 許可されたpassword
  def session_params
    session = params.require(:session).permit(:email, :password)
  end
end

