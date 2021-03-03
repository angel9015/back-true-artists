# frozen_string_literal: true

module StatusManagement
  extend ActiveSupport::Concern

  included do
    aasm column: 'status' do
      state :pending, initial: true
      state :pending_approval
      state :approved
      state :rejected

      event :pending_review do
        transitions from: :pending, to: :pending_approval
      end

      event :approve, after_commit: :send_status_notification do
        transitions from: :pending_approval, to: :approved
      end

      event :reject, after_commit: :send_status_notification do
        transitions from: :pending_approval, to: :rejected
      end
    end
  end

  def send_status_notification
    if instance_of?(Studio)
      StudioMailer.notify_on_account_status(email, status).deliver_now
    else
      ArtistMailer.notify_on_account_status(user.email, status).deliver_now
    end
  end
end
