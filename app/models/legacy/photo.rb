# frozen_string_literal: true

module Legacy
  class Photo < Base
    self.abstract_class = true
    self.table_name = 'photos'
    connects_to database: { reading: :legacy, writing: :primary }

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        where(photoable_type: 'Artist').find_each do |photo|
          ActiveRecord::Base.connected_to(role: :writing) do
            new_tattoo = ::Tattoo.find_or_initialize_by(id: photo.id, artist_id: photo.photoable_id)
            new_tattoo.placement = photo.tattoo_placements
            new_tattoo.color = photo.tattoo_colors
            new_tattoo.size = photo.tattoo_sizes
            new_tattoo.caption = photo.description
            new_tattoo.description = photo.description

            if new_tattoo.save && photo.attachment_file_name
              new_tattoo.image.purge if new_tattoo.image.present?
              image_file_name = photo.attachment_file_name
              image_extension = File.extname(image_file_name)
              optimized_file_name = "#{photo.tattoo_sizes} #{photo.tattoo_colors} #{photo.tattoo_placements} tattoo".slugorize.escape
              new_file_name = "#{optimized_file_name}"

              s3_image_url = "https://s3.amazonaws.com/trueartists_production/attachments/#{photo.id}/original/#{image_file_name.escape}"
              new_tattoo.image.attach(
                key: "artists/#{photo.photoable_id}/tattoos/#{new_tattoo.id}/#{new_file_name}",
                filename: new_file_name,
                io: URI.open(s3_image_url)
              )
            end
          end
        end
      end
    end
  end
end
