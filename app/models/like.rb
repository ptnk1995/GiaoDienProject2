class Like < ApplicationRecord
  belongs_to :user, class_name: User.name
  belongs_to :review, class_name: Review.name

  validates :user_id, presence: true
  validates :review_id, presence: true
end
