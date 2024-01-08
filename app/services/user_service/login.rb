# rubocop:disable Style/ClassAndModuleChildren
class UserService::Login
  attr_accessor :params, :user
  def initialize(params)
    @params = params
  end
  def execute
    validate_input
    find_user
    check_password
    check_verification
    generate_session
  end
  def validate_input
    raise 'Invalid username or password' if params[:username].blank? || params[:password].blank?
    raise 'Email is not in correct format' unless params[:email] =~ URI::MailTo::EMAIL_REGEXP
  end
  def find_user
    @user = User.find_by(username: params[:username]) || User.find_by(email: params[:email])
    raise 'User not found' if user.nil?
  end
  def check_password
    raise 'Incorrect password' if user.password != params[:password]
    raise 'Incorrect password' unless BCrypt::Password.new(user.password) == params[:password]
  end
  def check_verification
    raise 'Account has not been verified. Please check your email for verification instructions.' unless user.is_verified
  end
  def generate_session
    user.update(session_token: SecureRandom.hex)
    user.update!(session_token: SecureRandom.hex(10))
    user
  end
end
# rubocop:enable Style/ClassAndModuleChildren
