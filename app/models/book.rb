class Book < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :passive_rates, class_name: Rate.name,
    foreign_key: :book_id, dependent: :destroy
  has_many :raters, through: :passive_rates, source: :user

  mount_uploader :image, PictureUploader

  VALID_DATE_REGEX = /\A\d{4}\-(?:0?[1-9]|1[0-2])\-(?:0?[1-9]|[1-2]\d|3[01])\z/i

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  validates :author, presence: true, length: {maximum: 50}
  validates :url, presence: true
  validates :description, presence: true
  validates :publish_date, presence: true, format: {with: VALID_DATE_REGEX}

  scope :hottest, -> do
    order(rating: :desc).limit Settings.per_page
  end
  scope :search, ->search do
    where("name like ?", "%#{search}%").limit Settings.limit_book
  end
  scope :name_or_author, ->search do
    where "name LIKE ? OR author LIKE ?", "%#{search}%", "%#{search}%"
  end
  scope :newest, ->{order created_at: :desc}
  scope :except_id, ->id do
    where("id != ?", id).limit Settings.limit_book
  end
  scope :by_category, ->id do
    if id
      where("category_id != ?", id)
    else
      newest
    end
  end

  scope :search_name_or_author, ->search do
    if search
      name_or_author search
    else
      newest
    end
  end

  scope :favourite_list, -> user_id do
    Book.joins("INNER JOIN reading_books ON books.id = reading_books.book_id")
      .where("reading_books.user_id = ? AND reading_books.favorite = ?",
      user_id, true).limit Settings.limit_book
  end

  private
  def picture_size
    if image.size > Settings.size_image.megabytes
      errors.add :image, Settings.alert_size_image
    end
  end
end
