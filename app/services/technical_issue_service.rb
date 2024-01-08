# rubocop:disable Style/ClassAndModuleChildren
class TechnicalIssueService
  attr_accessor :user_id, :error_message
  def initialize(user_id, error_message)
    @user_id = user_id
    @error_message = error_message
  end
  def execute
    log_error
    friendly_error_message
  end
  private
  def log_error
    # Assuming we have a model called TechnicalIssue to log the errors
    TechnicalIssue.create(user_id: user_id, error_message: error_message)
  end
  def friendly_error_message
    {
      error_message: 'We are sorry, but something went wrong. Our team has been notified.',
      support_contact: 'For immediate assistance, please contact our support team at support@example.com'
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
