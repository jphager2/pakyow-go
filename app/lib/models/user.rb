require 'bcrypt'

class User < ActiveRecord::Base
  unless defined? EMAIL_REGEX 
    EMAIL_REGEX = /\A[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}\z/i
  end

  attr_accessor :password, :password_confirmation

  before_validation :downcase_email

  validates :email, format: { with: EMAIL_REGEX }, presence: true, uniqueness: true
  validates :password, presence: true
  validate :passwords_matching

  def self.auth(session)
    user = find_by(email: session[:email])

    if user && user.auth?(session.password)
      return user
    else
      return nil
    end
  end

  def auth?(password)
    BCrypt::Password.new(crypted_password) == password 
  end

  def password=(password)
    @password = password

    return if password.nil? || password.empty?
    self.crypted_password = BCrypt::Password.create(password)
  end

  private
  def downcase_email
    @email = @email.to_s.downcase
  end

  def passwords_matching
    if password && password != password_confirmation
      errors.add(:password, "and confirmation must match")
    end
  end
end