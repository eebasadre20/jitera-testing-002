# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::CheckStatus
  attr_accessor :user_id, :reservation_id
  def initialize(user_id, reservation_id)
    @user_id = user_id
    @reservation_id = reservation_id
  end
  def execute
    validate_input
    check_reservation
  end
  private
  def validate_input
    raise 'Invalid user_id' unless user_id.is_a?(Integer)
    raise 'Invalid reservation_id' unless reservation_id.is_a?(Integer)
  end
  def check_reservation
    reservation = Reservation.find_by(id: reservation_id, user_id: user_id)
    if reservation
      reservation.attributes.slice('restaurant_name', 'number_of_seats', 'date_time', 'special_requests')
    else
      raise 'Reservation not found'
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
