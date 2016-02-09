class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :logged_in

  MESSAGES = {
    successful_login: "You have successfully logged in! Nice work!",
    successful_logout: "You have logged out. We'll miss you.",
    success: "Success!",
    empty_search: "We don't have any ingredients that match your search!"
  }

  ERRORS = {
    login_error: "Invalid login. Please try again!",
    login_required: "You must be logged in to view this page!",
    account_exists: "You already have an account!",
    unsuccessful_signup: "There was a problem with your signup info. Please try again!",
    unsuccessful_save: "Could not save. Please check the information and try again.",
    wrong_login: "That's not your login! You can't access another Chef's secret sauce."
  }

  def require_login
    unless session[:user_id]
      redirect_to root_path, flash: { errors: ERRORS[:login_required] }
    end
  end

  def logged_in
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    flash[:error] = ERRORS[:login_required]
  end

  def save_previous_url
    session[:previous_url] = URI(request.referer || '').path
  end
end
