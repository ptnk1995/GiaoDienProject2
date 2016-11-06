class Category < ApplicationRecord
  scope :newest, ->{order created_at: :desc}

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  has_many :books, dependent: :destroy

  class << self
    def search search
      if search
        where "name LIKE ?", "%#{search}%"
      else
        newest
      end
    end
  end
end
