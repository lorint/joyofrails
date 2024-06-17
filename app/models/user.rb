class User < ApplicationRecord
  has_secure_password

  has_one :pending_email_exchange, -> { pending }, dependent: :destroy, class_name: "EmailExchange"
  has_many :email_exchanges, dependent: :destroy

  accepts_nested_attributes_for :email_exchanges, limit: 1

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  normalizes :email, with: ->(email) { email.downcase.strip }

  generates_token_for :confirmation, expires_in: 6.hours
  generates_token_for :password_reset, expires_in: 10.minutes

  def confirmable_email
    if pending_email_exchange.present?
      pending_email_exchange.email
    else
      email
    end
  end

  def reconfirming?
    pending_email_exchange.present?
  end

  def needs_confirmation?
    unconfirmed? || reconfirming?
  end

  def confirm!
    return false unless needs_confirmation?

    if reconfirming?
      transaction do
        update(email: pending_email_exchange.email)
        email_exchanges.archive!
      end
    end

    update_column(:confirmed_at, Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed? = !confirmed?
end