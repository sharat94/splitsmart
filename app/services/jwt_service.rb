class JwtService
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV["SECRET_KEY_BASE"])
  end

  def self.decode(token)
    body = JWT.decode(token, ENV["SECRET_KEY_BASE"])[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end
end
