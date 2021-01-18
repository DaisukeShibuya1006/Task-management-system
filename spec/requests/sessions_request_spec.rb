require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    context 'ログインページにアクセスすること' do
      it 'returns http success status code' do
        get '/login'
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインページにアクセスできないこと' do
      it 'returns a some type of error status code' do
        get '/not_login'
        expect(response).to have_http_status '404'
      end
    end
  end

  describe 'ログイン機能' do
    context 'ログイン成功' do
      before do
        @user = FactoryBot.build(:user)
      end

      it 'ログイン成功' do
        post '/login', params: {session: {email: 'user_email@jp', password: 'user_password'}}
        expect(response).to have_http_status '200'
      end

      it 'ログイン失敗' do
        post '/login', params: {session: {email: '', password: ''}}
        expect(response).to have_http_status '200'
      end
    end
  end

  describe 'ログアウト機能'do
    context 'ログアウト成功'
    it 'ログアウト成功' do
      delete '/logout'
      expect(response).to have_http_status '302'
    end
  end
end
