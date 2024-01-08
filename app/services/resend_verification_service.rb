# rubocop:disable Style/ClassAndModuleChildren
class ResendVerificationService
  attr_accessor :email, :user, :verification_email
  def initialize(email)
    @email = email
  end
  def execute
    find_user
    check_email_verified
    generate_verification_link
    update_verification_email
    send_verification_email
  end
  def find_user
    @user = User.find_by(email: email)
    raise 'Email is not registered' unless user
  end
  def check_email_verified
    raise 'Email is already verified' if user.email_verified
  end
  def generate_verification_link
    @verification_link = SecureRandom.urlsafe_base64
  end
  def update_verification_email
    @verification_email = VerificationEmail.find_by(user_id: user.id)
    verification_email.update(verification_link: verification_link, sent_at: Time.now)
  end
  def send_verification_email
    # Assuming we have a mailer setup
    UserMailer.with(user: user, verification_link: verification_link).verification_email.deliver_now
  end
end
# rubocop:enable Style/ClassAndModuleChildren
