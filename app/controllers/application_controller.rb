class ApplicationController < ActionController::Base
    before_action :set_logged_in

    private
    def authenticate!
        if Rails.application.config.password_enabled && !session[:vbt]
            redirect_to authenticate_path
        end
    end

    def set_logged_in
        @logged_in = session[:vbt]
    end
end
