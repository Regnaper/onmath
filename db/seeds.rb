User.create!(name:  "Ivan",
             email: "iv_vod@mail.ru",
             password:              "171007",
             password_confirmation: "171007",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

0.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
0.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

10.times do |n|
  name  = "Test-#{n+1}"
  theme = "Theme-#{n.div(5)+1}"
  subtheme = "Subtheme-#{n.div(2)+1}"
  test = Test.create!(name:  name,
               theme: theme,
               subtheme: subtheme)
  10.times do |k|
    question  = "Question-#{k+1}"
    right_answer = rand(4) + 1
    question = test.questions.create!(question: question, right_answer: right_answer)
    4.times do |l|
      answer  = "Answer-#{l+1}"
      question.answers.create!(answer: answer)
    end
  end
end

