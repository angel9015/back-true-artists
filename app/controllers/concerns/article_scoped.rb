# frozen_string_literal: true

module ArticleScoped
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_article, except: %i[index]
  end

  private

  def search
    @search = ArticleSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: 'published'
    }.delete_if { |_k, v| v.nil? }
  end

  def find_article
    @article = Article.fetch_by_slug_and_status(params[:id], 'pubslished').first
    head(:not_found) unless @article
  end
end
