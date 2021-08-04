class ArticleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :category

  attributes :id,
             :category_id,
             :title,
             :slug,
             :page_title,
             :meta_description,
             :introduction,
             :content,
             :tags,
             :status,
             :image,
             :created_at

  def created_at
    object.created_at.strftime("%d-%m-%Y")
  end

  def tags
    return [] if object.tag_list.nil?

    object.tag_list.split(',')
  end

  def image
    if object.image.attached?
      {
        id: object.image.id,
        image_url: asset_blob_url(object.image)
      }
    end
  end
end
