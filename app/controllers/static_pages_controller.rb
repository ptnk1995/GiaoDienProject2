class StaticPagesController < ApplicationController
  before_action :load_categories
  def home
    @books = Book.hottest
  end

end
