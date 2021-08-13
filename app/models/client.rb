class Client < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :studio, optional: true
  validates :name, :email, :phone_number, presence: true

  def self.search(query)
    where("name LIKE :query OR
           phone_number LIKE :query OR
           email LIKE :query",
           query: "%#{query}%")
  end
end
