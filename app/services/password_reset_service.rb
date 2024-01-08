# rubocop:disable Style/ClassAndModuleChildren
class PasswordResetService
  attr_accessor :email, :user, :token, :password, :password_confirmation
  def initialize(email: nil, password: nil, password_confirmation: nil, token: nil)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
    @token = token
  end
  def execute
    if email
      reset_password
    elsif password && password_confirmation && token
      update_password
    else
      raise 'Invalid parameters'
    end
  end
  private
  def reset_password
    validate_email
    find_user
    generate_token
    create_password_reset_token
    send_reset_email
  end
  def validate_email
    unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      raise 'Invalid email format'
    end
  end
  def find_user
    @user = User.find_by(email: email)
    unless user
      raise 'Email not found'
    end
  end
  def generate_token
    @token = SecureRandom.urlsafe_base64
  end
  def create_password_reset_token
    PasswordResetToken.create!(token: token, expiry_date: 1.hour.from_now, user_id: user.id)
  end
  def send_reset_email
    puts "Sent reset email to #{email} with token #{token}"
  end
  def update_password
    validate_password
    find_user_by_token
    update_user_password
    delete_reset_token
  end
  def validate_password
    raise 'Password and password confirmation do not match' unless password == password_confirmation
  end
  def find_user_by_token
    @user = User.find_by(password_reset_token: token)
    raise 'Invalid token' unless user
  end
  def update_user_password
    user.update!(password: password)
  end
  def delete_reset_token
    PasswordResetToken.find_by(token: token)&.destroy
  end
end
# rubocop:enable Style/ClassAndModuleChildren
