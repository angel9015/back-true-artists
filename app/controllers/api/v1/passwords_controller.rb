module Api::V1
  class PasswordsController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[create]
    before_action :validate_confirmation_token, only: %i[update]
    before_action :find_user, only: %i[create]

    def update
      @user = current_user
      if @user.set_new_password(change_password_params)
        head(:ok)
      else
        render_api_error(status: 422, errors: @user.errors)
      end
    end

    def create
      if @user.reset_password_request
        head(:ok)
      else
        render_api_error(status: 422, errors: 'Request could not be made.')
      end
    end

    private

    def find_user
      @user = User.find_by(email: password_change_request_params[:email])
      head(:not_found) unless @user
    end

    def change_password_params
      params.permit(:password, :password_confirmation)
    end

    def password_change_request_params
      params.permit(:email)
    end
  end
end
