User.create! name: "Quyen Nguyen", email: "quyenguyengoc911@gmail.com",
  password: "123456", password_confirmation: "123456",
  role: 0, image: "avatar.jpg"
User.create! name: "Hanh Tran", email: "myhanhqt96@gmail.com",
  password: "123456", password_confirmation: "123456",
  role: 0, image: "avatar.jpg"
User.create! name: "Nhat Nguyen", email: "nguyenhoangnhat07@gmail.com",
  password: "123456", password_confirmation: "123456",
  role: 0, image: "avatar.jpg"
User.create! name: "Mod", email: "mod@gmail.com",
  password: "123456", password_confirmation: "123456",
  role: 1, image: "avatar.jpg"
User.create! name: "User", email: "user@gmail.com",
  password: "123456", password_confirmation: "123456",
  role: 2, image: "avatar.jpg"

Category.create!(name: "Animals and Pets")
Category.create!(name: "Business")
Category.create!(name: "Cooking, Food and Drink")
Category.create!(name: "Fiction")
Category.create!(name: "Gardening")
Category.create!(name: "History")
Category.create!(name: "Kids")
Category.create!(name: "Science and Nature")
Category.create!(name: "The Arts")
Category.create!(name: "Travel")
Category.create!(name: "Teens and YA")
Category.create!(name: "Poetry")

categories = Category.order(:created_at).take(12)
publish_date = "2016-10-07"
url = "http://stackoverflow.com/"
categories.each do |category|
  8.times do
    description = Faker::Lorem.paragraph
    author = Faker::Name.name
    name = Faker::Name.name
    category.books.create!(description: description, name: name,
      publish_date: publish_date, author: author, url: url)
  end
end

books = Book.order(:created_at).take(20)
users = User.order(:created_at).take(5)
books.each do |book|
  users.each do |user|
    title = Faker::Name.title
    content = Faker::Lorem.paragraph
    book.reviews.create!(title: title, content: content, user_id: user.id)
  end
end

reviews = Review.order(:created_at).take(50)
reviews.each do |review|
  users.each do |user|
    user.like review
    content = Faker::Hacker.say_something_smart
    review.comments.create!(content: content, user_id: user.id)
  end
end

users = User.all
user  = users.first
following = users[4, 5]
followers = users[2, 3]
following.each { |followed| user.follow followed }
followers.each { |follower| follower.follow user }

books_favorite = books[1..10]
books_favorite.each do |book_favorite|
  users.each do |user|
    ReadingBook.create! favorite: 1, book_id: book_favorite.id, user_id: user.id
  end
end
