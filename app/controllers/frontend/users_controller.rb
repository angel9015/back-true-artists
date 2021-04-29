# frozen_string_literal: true

module Frontend
  class UsersController < FrontendController
    skip_before_action :authenticate_request!, only: %i[create]
    before_action :fail_if_unauthenticated!, except: %i[create]
    before_action :find_user, except: %i[create]

    def create
      user = User.new(user_create_params)
      if user.save
        auth_token = JsonWebToken.encode(user_id: user.id)

        render json: {
          user: UserSerializer.new(user, root: false),
          auth_token: auth_token
        }, status: :created
      else
        render_api_error(status: 422, errors: user.errors)
      end
    end

    def show
      render json: UserSerializer.new(@user).to_json, status: :ok
    end

    def update
      if @user.update(user_update_params)
        render json: UserSerializer.new(@user).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @user.errors)
      end
    end

    def destroy
      if @user.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    private

    def find_user
      @user = current_user
    end

    def user_update_params
      params.require(:user).permit(:email)
    end

    def user_create_params
      params.permit(:email,
                    :full_name,
                    :social_id,
                    :provider,
                    :status,
                    :password,
                    :password_confirmation).tap do |whitelisted|
        if params[:social_id].present?
          whitelisted[:password] =
            whitelisted[:password_confirmation] = SecureRandom.hex(8)
        end
      end
    end
  end
end
