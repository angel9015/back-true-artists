# frozen_string_literal: true

module Legacy
  class User < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |user|
          new_user = User.find_or_initialize_by(email: user.email)
          new_user.full_name = "#{user.first_name} #{user.last_name}"
          new_user.password_digest = user.encrypted_password

          new_user.save
        end
      end
    end
  end
end
