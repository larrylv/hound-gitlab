class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    user = find_user || create_user
    create_session_for(user)
    redirect_to repos_path
  end

  def destroy
    destroy_session
    redirect_to root_path
  end

  private

  def find_user
    User.where(gitlab_username: gitlab_username).first
  end

  def create_user
    user = User.create!(
      gitlab_username: gitlab_username,
      email_address: gitlab_email_address
    )
    flash[:signed_up] = true
    user
  end

  def create_session_for(user)
    session[:remember_token] = user.remember_token
    session[:gitlab_token] = gitlab_token
  end

  def destroy_session
    session[:remember_token] = nil
  end

  def gitlab_username
    request.env["omniauth.auth"]["info"]["nickname"]
  end

  def gitlab_email_address
    request.env["omniauth.auth"]["info"]["email"]
  end

  def gitlab_token
    request.env["omniauth.auth"]["credentials"]["token"]
  end
end
