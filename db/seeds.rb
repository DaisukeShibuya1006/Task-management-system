User.create!(name: "test_name1",
            email: "test_mail@jp",
            password_digest: "test_password1")


10.times do |n|
   Task.create!(title: "test_title#{n+1}",
               text: "test_text#{n+1}",
               status: rand(0..2),
               priority: rand(0..2),
               user_id: 1)
end
