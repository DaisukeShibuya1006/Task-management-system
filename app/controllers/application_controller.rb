class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['BASIC_AUTH_NAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'production'

  helper_method :current_user
  before_action :login_required

  private

  # 登録されている自身のユーザ情報を取得
  # ユーザが確認できない場合はUser.idとセッションが持っているuser_idが一致するユーザを抽出
  # @return[User] 自身のユーザ情報
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログイン中のユーザか確認
  # 未ログインならば、ログイン画面に移行
  def login_required
    redirect_to login_url unless current_user
  end
end
