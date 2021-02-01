class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :login_required

  def new; end

  # ログインする
  # 入力されたemailがUserモデル内のemailと一致するかを確認する
  # emailが存在すれば、passwordが一致するかを確認し、emailが存在しなければ、nilを返す
  # @return[User] ログインができるとき、またはemailが存在するとき
  # @return[nil] emailが一致しない場合
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

  # ログアウトする
  # 全てのセッション情報を削除する
  # @return[nil] ログアウト
  def destroy
    reset_session
    flash[:success] = 'ログアウトしました'
    redirect_to login_path
  end

  private

  # 許可されたパラメータのみ通過させる
  # @param[ActionController::Parameters] 許可されたパラメータのみ通過
  def session_params
    session = params.require(:session).permit(:email, :password)
  end
end
