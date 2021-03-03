# frozen_string_literal: true

module Api::V1
  class StudiosController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_studio, except: %i[create index verify_phone]

    def index
      @results = StudioSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def city
      Studio.near(params[:city], 500)
    end

    def show
      render json: StudioSerializer.new(@studio).to_json, status: :ok
    end

    def create
      studio = current_user.build_studio(studio_params)

      if studio.save
        render json: StudioSerializer.new(studio).to_json, status: :created
      else
        render_api_error(status: 422, errors: studio.errors)
      end
    end

    def update
      studio = BaseForm.new(@studio, studio_params).update

      if studio
        render json: StudioSerializer.new(@studio).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def invite_artist
      if @studio.invite_artist(artist_invite_params)
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def verify_phone
      studio = current_user.studio.verify_phone(phone_verification_params[:code])

      if studio
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

    private

    def find_studio
      @studio = Studio.find(params[:id])
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status],
        near: params[:city] || params[:near],
        within: params[:within]
      }.delete_if { |_k, v| v.nil? }
    end

    def phone_verification_params
      params.permit(:code)
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
        :slug,
        :services,
        :specialty,
        :website_url,
        :facebook_url,
        :twitter_url,
        :instagram_url,
        :phone_number,
        :minimum_spend,
        :price_per_hour,
        :currency_code,
        :street_address,
        :city,
        :state,
        :zip_code,
        :country,
        :seeking_guest_spot,
        :guest_studio,
        :avatar,
        :hero_banner
      )
    end
  end
end
