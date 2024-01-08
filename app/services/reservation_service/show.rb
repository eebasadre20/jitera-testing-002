# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Show
  attr_accessor :params, :reservation
  def initialize(params, _current_user = nil)
    @params = params
  end
  def execute
    validate_reservation_id
    retrieve_reservation_details
    format_reservation_details
  end
  def validate_reservation_id
    @reservation = Reservation.find_by(id: params[:reservation_id])
    raise ActiveRecord::RecordNotFound, 'Reservation not found' unless @reservation
  end
  def retrieve_reservation_details
    @reservation = Reservation.find(params[:reservation_id])
  end
  def format_reservation_details
    {
      id: @reservation.id,
      reservation_date_time: @reservation.reservation_date_time,
      restaurant_name: @reservation.restaurant_name,
      seats_reserved: @reservation.seats_reserved,
      reservation_status: @reservation.reservation_status,
      special_requests: @reservation.special_requests,
      reservation_code: @reservation.reservation_code,
      user_id: @reservation.user_id,
      reservation_date: @reservation.reservation_date,
      status: @reservation.status,
      restaurant_id: @reservation.restaurant_id,
      number_of_seats: @reservation.number_of_seats,
      date_time: @reservation.date_time
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
