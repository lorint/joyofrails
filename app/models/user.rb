class User < ApplicationRecord
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.downcase.strip }

  has_secure_password

  generates_token_for :confirmation, expires_in: 6.hours

  def confirm!
    update_column(:confirmed_at, Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    Emails::UserMailer.confirmation(self, confirmation_token).deliver_now
  end
end
