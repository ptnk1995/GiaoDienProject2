class ApplicationController < ActionController::Base
  layout 'application'
  include SessionsHelper
  protect_from_forgery with: :exception

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "require_login"
      redirect_to login_url
    end
  end

  def load_categories
    @categories = Category.all
  end
end
