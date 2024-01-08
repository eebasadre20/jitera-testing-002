# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Update
  attr_accessor :params, :reservation
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @reservation = Reservation.find_by(id: params[:reservation_id] || params[:id], user_id: current_user.id)
  end
  def execute
    validate_reservation_and_user
    update_reservation
    confirmation_message
  end
  private
  def validate_reservation_and_user
    raise 'Invalid reservation or user' if @reservation.nil?
  end
  def update_reservation
    @reservation.update(
      restaurant_id: params[:restaurant_id],
      restaurant_name: params[:restaurant_name],
      reservation_date: params[:reservation_date],
      seats_reserved: params[:seats_reserved],
      status: params[:status],
      reservation_status: params[:reservation_status],
      special_requests: params[:special_requests],
      reservation_code: params[:reservation_code],
      reservation_date_time: params[:reservation_date_time]
    )
  end
  def confirmation_message
    'Reservation has been successfully modified.'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
