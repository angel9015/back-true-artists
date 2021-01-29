# frozen_string_literal: true

class Studio < ApplicationRecord
  include AssetExtension
  has_many :studio_invites, dependent: :destroy
  has_many :studio_artists
  has_many :artists, through: :studio_artists

  validates :email, presence: true
  validates :user_id, uniqueness: true

  def invite_artist(attrs = {})
    return if attrs.empty?

    artist = if attrs[:email].present?
               Artist.joins(:user).find_by({ users: { email: attrs[:email] } })
             else
               Artist.find_by(phone_number: attrs[:phone_number])
             end

    studio_invite = if studio_invites.where(email: attrs[:email])
                      studio_invites.where(email: attrs[:email]).first
                    else
                      studio_invites.where(phone_number: attrs[:phone_number]).first
                    end

    if studio_invite.present?
      # send reminder email instead
      # studio_invite.send_invitation_reminder
    else
      studio_invite = studio_invites.new(
        artist_id: artist&.id,
        phone_number: attrs[:phone_number],
        email: attrs[:email]
      )
      studio_invite.send_invitation if studio_invite.save
      studio_invite
    end
  end
end
