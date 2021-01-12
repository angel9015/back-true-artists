# frozen_string_literal: true

class Api::V1::StudiosController < ApplicationController
  before_action :find_studio, except: %i[create index]

  def index
    @studios = paginate(Studio.all)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@studios,
                                                                   serializer: StudioSerializer),
           status: :ok
  end

  def show
    render json: StudioSerializer.new(@studio).to_json, status: :ok
  end

  def create
    studio = Studio.new(studio_params)
    studio.user_id = @current_user&.id

    if studio.save
      render json: StudioSerializer.new(studio).to_json, status: :created
    else
      render_api_error(status: 422, errors: studio.errors)
    end
  end

  def update
    if @studio.update(studio_params)
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

  private

  def find_studio
    @studio = Studio.find(params[:id])
  end

  def artist_invite_params
    params.permit(
      :id,
      :email
    )
  end

  def studio_params
    params.permit(
      :user_id,
      :email,
      :lat,
      :lon,
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
      :years_of_experience,
      :services,
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
      :city,
      :state,
      :zip_code,
      :country,
      :seeking_guest_spot,
      :guest_studio,
      :attachments_attributes: [:image]
    )
  end
end
