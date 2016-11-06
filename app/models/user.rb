class User < ApplicationRecord
  attr_accessor :remember_token

  before_save {email.downcase!}

  enum role: [:admin, :mod, :user]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  validates :name,  presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, on: :create
  validates :password, length: {minimum: 6}, allow_blank: true, on: :update

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :active_likes, class_name: Like.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :active_rates, class_name: Rate.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :liking, through: :active_likes, source: :review
  has_many :rating, through: :active_rates, source: :book
  has_many :reviews, dependent: :destroy
  has_many :requests
  has_many :comments

  def is_user? user
    self == user
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  scope :search_name, ->search do
    where("name like ?", "%#{search}%").limit Settings.limit_book
  end

  scope :favourite_list, -> user_id do
    Book.joins("INNER JOIN reading_books ON books.id = reading_books.book_id")
      .where("reading_books.user_id = ? AND reading_books.favorite = ?",
      user_id, true).limit Settings.limit_book
  end

  scope :likes_number, -> review_id do
    Like.where "review_id = ?", review_id
  end

  def is_user? user
    self == user
  end

  def is_admin?
    self.role == "admin"
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include?other_user
  end

  def like review
    active_likes.create review_id: review.id
  end

  def unlike review
    active_likes.find_by(review_id: review.id).destroy
  end

  def liking? review
    liking.include?review
  end

  def rate book, value
    active_rates.create book_id: book.id, rate: value
    book.update_attributes rating: book.raters.average(:rate)
  end

  def rerate book, value
    active_rates.find_by(book_id: book.id).update_attributes rate: value
    book.update_attributes rating: book.raters.average(:rate)
  end

  def rating? book
    rating.include?book
  end
end
