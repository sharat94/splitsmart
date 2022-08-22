# frozen_string_literal: true

class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private
  def user
    user = User.find_by(email: email)
    return user if user&.valid_password?(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
