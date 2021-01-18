FactoryBot.define do
  factory :task do
    title { 'Test_tilte' }
    text { 'Test_text' }
    user
  end
end
