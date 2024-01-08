# rubocop:disable Style/ClassAndModuleChildren
class PasswordResetTokenService::Verify
  attr_accessor :token, :password_reset_token
  def initialize(token)
    @token = token
  end
  def execute
    find_token
    validate_token
    success_message
  end
  def find_token
    @password_reset_token = PasswordResetToken.find_by(token: token)
    raise 'Token not found' unless @password_reset_token
  end
  def validate_token
    if password_reset_token.expiry_date < Time.now
      raise 'Token has expired'
    end
  end
  def success_message
    'Token is valid'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
