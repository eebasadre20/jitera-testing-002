# rubocop:disable Style/ClassAndModuleChildren
class UserService::RetrieveReservations
  attr_accessor :user_id, :reservations
  def initialize(user_id)
    @user_id = user_id
    @reservations = Reservation
  end
  def execute
    validate_user_id
    retrieve_reservations
    paginate
  end
  def validate_user_id
    raise 'User does not exist' unless User.exists?(user_id)
  end
  def retrieve_reservations
    @reservations = Reservation.where('user_id = ?', user_id)
  end
  def paginate
    @reservations = Reservation.none if reservations.blank?
    @reservations = reservations.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
