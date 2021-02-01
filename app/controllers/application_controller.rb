class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['BASIC_AUTH_NAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'production'

  helper_method :current_user
  before_action :login_required


  # sessionに一致するユーザを返す
  # @current_userがnilまたはfalseのとき、Userモデルのuser_idとsession[:user_id]を一致させる
  # @return[User] ログイン中のユーザを返す
  # @return[nil] 一致するユーザがいない場合
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログイン中のユーザでなければ、ログイン画面にリダイレクトさせる
  def login_required
    redirect_to login_url unless current_user
  end
end
