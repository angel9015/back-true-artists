# frozen_string_literal: true

module Legacy
  class Category < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |category|
          connected_to(role: :writing) do
            new_category = ::Category.find_or_initialize_by(name: category.name)
            new_category.save(validate: false)
          end
        end
      end
    end
  end
end
