10000.times do |n|
   User.create!(name: "testuser#{n+1}",
               email: "testuser#{n+1}@hoge.jp",
               password_digest: "testuser#{n+1}")
end

100000.times do |n|
   Task.create!(title: "testtitle#{n+1}",
               text: "testtext#{n+1}",
               status: rand(0..2),
               priority: rand(0..2),
               user_id: rand(1..10000))
end
