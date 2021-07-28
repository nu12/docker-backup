class SessionController < ApplicationController
  def new
    unless Rails.application.config.password_enabled
      redirect_to root_path
    end
  end

  def create
    password = params[:password]
    if password == Rails.application.config.password
      session[:vbt] = true
    end
    redirect_to root_path
  end

  def destroy
    session[:vbt] = false
    redirect_to root_path
  end
end
