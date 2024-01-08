# rubocop:disable Style/ClassAndModuleChildren
class UserRegistrationService
  attr_accessor :params, :user
  def initialize(params)
    @params = params
  end
  def execute
    validate_params
    check_existing_email
    create_user
    generate_verification_link
    send_verification_email
  end
  private
  def validate_params
    # Add your validation logic here
    # Raise an exception if validation fails
  end
  def check_existing_email
    existing_user = User.find_by(email: params[:email])
    raise 'Email already in use' if existing_user
  end
  def create_user
    @user = User.new(params)
    @user.password = BCrypt::Password.create(params[:password])
    @user.save!
  end
  def generate_verification_link
    verification_link = SecureRandom.uuid
    VerificationEmail.create!(user_id: @user.id, verification_link: verification_link)
  end
  def send_verification_email
    # Add your email sending logic here
  end
end
# rubocop:enable Style/ClassAndModuleChildren
