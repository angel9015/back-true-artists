# frozen_string_literal: true

module Api::V1::Admin
  class StudiosController < BaseController
    before_action :find_studio, except: %i[index reject_image]

    def index
      @results = StudioSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: StudioSerializer.new(@studio).to_json, status: :ok
    end

    def update
      studio = BaseForm.new(@studio, studio_params).update

      if studio
        render json: StudioSerializer.new(@studio).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def approve
      if @studio.approve!
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def reject
      if @studio.reject!
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def destroy
      if @studio.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def remove_image
      attachment = ActiveStorage::Attachment.find(params[:image_id]).purge
      if attachment.blank?
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    def reject_image
      attachment = ActiveStorage::Attachment.find(params[:image_id])

      if attachment.update(status: 'rejected')
        head(:ok)
      else
        render_api_error(status: 422, errors: 'Resource could not be rejected')
      end
    end

    def invite_artist
      authorize @studio

      studio_invite = @studio.studio_invites.new(artist_invite_params)

      if studio_invite.invite_artist_to_studio
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def studio_invites
      authorize @studio

      invites = @studio.studio_invites.where(accepted: false)

      render json: ActiveModel::Serializer::CollectionSerializer.new(invites,
                                                                     serializer: StudioInviteSerializer), status: :ok
    end

    private

    def find_studio
      @studio = Studio.find(params[:id])
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status],
        near: params[:near],
        within: params[:within]
      }.delete_if { |_k, v| v.nil? }
    end

    def studio_params
      params.permit(
        :email,
        :accepting_guest_artist,
        :piercings,
        :cosmetic_tattoos,
        :appointment_only,
        :vegan_ink,
        :wifi,
        :privacy_dividers,
        :wheelchair_access,
        :parking,
        :lgbt_friendly,
        :languages,
        :name,
        :bio,
        :specialty,
        :website,
        :facebook_url,
        :twitter_url,
        :instagram_url,
        :phone_number,
        :minimum_spend,
        :price_per_hour,
        :currency_code,
        :street_address,
        :street_address_2,
        :city,
        :state,
        :zip_code,
        :country,
        :seeking_guest_spot,
        :guest_studio,
        :avatar,
        :hero_banner,
        working_hours: {},
        services: []
      )
    end
  end
end
