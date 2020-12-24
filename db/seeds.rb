User.create!(name: "testname1",
            email: "testmail@jp",
            password_digest: "testpassword1")


10.times do |n|
   Task.create!(title: "testtitle#{n+1}",
               text: "testtext#{n+1}",
               status: rand(0..2),
               priority: rand(0..2),
               user_id: 1)
end
