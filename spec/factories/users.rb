FactoryBot.define do
  factory :user do
    name { 'user_name' }
    email { 'user_email' }
    password_digest { 'user_password' }
  end
end
