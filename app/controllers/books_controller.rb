class BooksController < ApplicationController
  before_action :load_book, only: [:show]
  before_action :load_categories
  def index
    if params[:category].blank?
      @books = Book.newest.paginate page: params[:page],
        per_page: Settings.per_page
    else
      @category = Category.find_by id: params[:category]
      unless @category
        flash[:danger] = t "record_isnt_exist"
        redirect_to books_path
      else
        @books = @category.books.newest.paginate page: params[:page],
          per_page: Settings.per_page
      end
    end
  end

  def show
    @books_relate = @book.category.books.except_id(@book.id).newest
    @reviews = @book.reviews.includes(:user, comments: :user).newest
      .paginate page: params[:page], per_page: Settings.per_page
    if logged_in?
      @review = @book.reviews.build
      @rate = @book.raters.build
    end
  end

  private
  def load_book
    @book = Book.find_by id: params[:id]
    unless @book
      flash[:warning] = t "record_isnt_exist"
      redirect_to root_url
    end
  end
end
