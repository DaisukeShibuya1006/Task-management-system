require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    context 'when accessing to login page' do
      it 'returns http success status code' do
        get '/login'
        expect(response).to have_http_status '200'
      end
    end

    context 'when cannot accesse to login page' do
      it 'returns a some type of error status code' do
        get '/not_login'
        expect(response).to have_http_status '404'
      end
    end
  end

  describe 'POST /login' do
    before do
      FactoryBot.create(:user)
    end

    context 'when correct input name and password' do
      it 'Login success' do
        post '/login', params: { session: { email: 'user_email@jp', password: 'user_password' } }
        expect(response).to have_http_status '302'
      end
    end

    context 'when incorrect input name and password' do
      it 'Login failure' do
        post '/login', params: { session: { email: '', password: '' } }
        expect(response).to have_http_status '401'
      end
    end
  end

  describe 'DELETE /logout' do
    it 'Logout success' do
      delete '/logout'
      expect(response).to have_http_status '302'
    end
  end
end
