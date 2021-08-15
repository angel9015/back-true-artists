# frozen_string_literal: true

module Api::V1
  class StylesController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_style, except: %i[index]

    def index
      @styles = Style.find_all_cached
      render json: ActiveModel::Serializer::CollectionSerializer.new(@styles,
                                                                     serializer: StyleSerializer),
             status: :ok
    end

    def show
      render json: StyleSerializer.new(@style).to_json, status: :ok
    end

    private

    def find_style
      @style = Style.friendly.find(params[:id])
    end

    def style_params
      params.permit(:name, :avatar)
    end
  end
end
