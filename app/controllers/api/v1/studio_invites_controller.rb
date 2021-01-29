# frozen_string_literal: true

module Api::V1
  class StudioInvitesController < ApplicationController
    before_action :find_studio, except: %i[accept_studio_invite]
    before_action :find_studio_invite, only: %i[accept_studio_invite]

    def create
      studio_invite = @studio.studio_invites.new(artist_invite_params)

      if studio_invite.add_studio_invite
        head(:ok)
      else
        render_api_error(status: 422, errors: studio_invite.errors)
      end
    end

    def accept_studio_invite
      artist = current_user.artist

      if artist.present?
        if @studio_invite.add_artist_to_studio(artist&.id)
          head(:ok)
        else
          render_api_error(status: 422, errors: @studio_invite.errors)
        end
      else
        render_api_error(status: 422, errors: 'User is not an artist')
      end
    end

    private

    def find_studio
      @studio = Studio.find_by(user_id: current_user&.id)

      head(:not_found) unless @studio
    end

    def find_studio_invite
      @studio_invite = StudioInvite.find_by(invite_code: params[:token])

      head(:not_found) unless @studio_invite
    end

    def artist_invite_params
      params.permit(
        :phone_number,
        :email
      )
    end
  end
end
