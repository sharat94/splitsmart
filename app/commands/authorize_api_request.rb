# frozen_string_literal: true

class AuthorizeApiRequest

  attr_reader :headers

  def initialize(headers = {})
    @headers = headers
  end

  def authorize
    user
  end

  private

  def user
    @user ||= User.find(decoded_auth_token[:id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JwtService.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end

    nil
  end
end
