# Seed users

User.destroy_all

earliest_birthday = (Time.now - 60.years).strftime('%Y-%m-%d')
latest_birthday = (Time.now - 15.years).strftime('%Y-%m-%d')

100.times do |y|
  i = rand(0..1)
  gendered_names = [Faker::Name.unique.female_first_name, Faker::Name.unique.male_first_name]
  first_name = gendered_names[i]
  name = [first_name, Faker::Name.unique.last_name]

  User.create(
    email: name.join('.').downcase << %w[ @outlook.com @gmail.com @yahoo.com msn.com ].sample,
    first_name: first_name,
    last_name: name.last,
    gender: i.zero? ? 'Female' : 'Male',
    birthday: Faker::Date.between(from: earliest_birthday, to: latest_birthday),
    password: SecureRandom.base64(10),
    image_attributes: { remote_photo: Faker::LoremFlickr.image(size: "128x128") << "?random=#{y}" }
  )
end

Users = User.all

# Seed friendships

Friendship.destroy_all

Users.each do |user|
  rand(10..20).times do 
    friend = Users.sample
    user.friends << friend unless friend == user || user.friend?(friend)
  end
end

# Seed posts

Post.destroy_all

Users.each do |user|
  rand(1..10).times do
    creation_time = Time.now - rand(50000000)
    user.posts.create(
      content: Faker::Lorem.paragraph_by_chars(number: rand(128..4096), supplemental: false),
      created_at: creation_time,
      updated_at: creation_time,
      images_attributes: rand(3).times.map.with_index { |i| [i.to_s, { remote_photo: Faker::LoremFlickr.image(size: "1280x720") << "?random=#{rand(5000)}" }] }.to_h,
      tag_list_attributes: { list: Faker::Lorem.words(number: rand(10)).join(',') }
    )
  end
end

Posts = Post.all

# Seed post comments

Comment.destroy_all

400.times do
  post = Posts.sample
  user = Users.sample
  comment_body = Faker::Lorem.paragraph_by_chars(number: rand(128..512))
  post.comments.create(body: comment_body, user: user)
end

Comments = Comment.all

# Seed post sub-comments

400.times do
  comment = Comments.sample
  user = Users.sample
  comment_body = Faker::Lorem.paragraph_by_chars(number: rand(128..512))
  comment.replies.create(body: comment_body, user: user, commentable: comment.commentable)
end

# Seed likes

1000.times do |i|
  resource = i.even? ? Posts.sample : Comments.sample
  user = Users.sample
  resource.likes.create(user: user)
end
