class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['BASIC_AUTH_NAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'production'

  helper_method :current_user
  before_action :login_required

  private

  # ログイン中のユーザを呼び出す
  # @current_userがnilまたはfalseのとき、Userモデルのuser_idとsession[:user_id]を一致させる
  # @return[Object] ログイン中のユーザ
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログイン中のユーザでなければ、ログイン画面にリダイレクトさせる
  # return[Object]
  def login_required
    redirect_to login_url unless current_user
  end
end
