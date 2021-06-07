# frozen_string_literal: true

module Api
  module V1
    class ConventionsController < ApplicationController
      before_action :find_convention, except: %i[create index]

      def index
        @results = ConventionSearch.new(
          query: params[:query],
          options: search_options
        ).filter

        render json: @results, status: :ok
      end

      def show
        render json: ConventionSerializer.new(@convention).to_json, status: :ok
      end

      def create
        convention = current_user.conventions.new(convention_params)

        if convention.save
          render json: ConventionSerializer.new(convention).to_json, status: :created
        else
          render_api_error(status: 422, errors: convention.errors)
        end
      end

      def submit_for_review
        @convention.pending_review

        if @convention.save
          head(:ok)
        else
          render_api_error(status: 422, errors: @convention.errors)
        end
      end

      def update
        convention = BaseForm.new(@convention, convention_params).update

        if convention
          render json: ConventionSerializer.new(@convention).to_json, status: :ok
        else
          render_api_error(status: 422, errors: @convention.errors)
        end
      end

      private

      def find_convention
        @convention = Convention.friendly.find(params[:id])

        if @convention.created_by != current_user.id
          @convention = Convention.friendly.verified_conventions.upcoming_conventions.find(params[:id])
        end
      end

      def convention_params
        params.permit(
          :name,
          :description,
          :address,
          :city,
          :state,
          :country,
          :link_to_official_site,
          :facebook_link,
          :start_date,
          :end_date,
          :image
        )
      end

      def search_options
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || BaseSearch::PER_PAGE,
          status: params[:status],
          near: params[:city] || params[:near],
          verified: true,
          time_constraint: Date.today,
          within: params[:within],
          user_role: current_user.role
        }.delete_if { |_k, v| v.nil? }
      end
    end
  end
end
