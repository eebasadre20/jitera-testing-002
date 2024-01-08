# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::GetDetails
  attr_accessor :user_id, :reservation_code
  def initialize(user_id, reservation_code)
    @user_id = user_id
    @reservation_code = reservation_code
  end
  def execute
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    reservation = Reservation.find_by(reservation_code: reservation_code)
    return { error: 'Reservation not found' } unless reservation
    return { error: 'User not authorized to view this reservation' } unless reservation.user_id == user_id
    reservation_details = {
      reservation_date_time: reservation.reservation_date_time,
      restaurant_name: reservation.restaurant_name,
      seats_reserved: reservation.seats_reserved,
      special_requests: reservation.special_requests,
      reservation_code: reservation.reservation_code
    }
    reservation_details
  end
end
# rubocop:enable Style/ClassAndModuleChildren
