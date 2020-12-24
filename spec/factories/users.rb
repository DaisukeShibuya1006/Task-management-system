FactoryBot.define do
  factory :user do
    name { 'username' }
    email { 'email' }
    password_digest { 'password' }
  end
end
