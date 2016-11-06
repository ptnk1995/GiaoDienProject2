class Rate < ApplicationRecord
  belongs_to :user, class_name: User.name
  belongs_to :book, class_name: Book.name

  validates :user_id, presence: true
  validates :book_id, presence: true
end
