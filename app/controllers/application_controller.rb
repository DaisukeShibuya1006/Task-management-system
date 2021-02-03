class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['BASIC_AUTH_NAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'production'

  helper_method :current_user
  before_action :login_required

  private

  # sessionに一致するユーザを返す
  # sessionにユーザがあれば、User情報を返す
  # @return[User] ログイン中のユーザ
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログイン中のユーザでなければ、ログイン画面にリダイレクト
  def login_required
    redirect_to login_url unless current_user
  end
end
