# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Cancel
  attr_accessor :user_id, :reservation_id, :reservation, :params, :user, :restaurant
  def initialize(params, _current_user = nil)
    @params = params
    @user_id = params[:user_id]
    @reservation_id = params[:reservation_id]
  end
  def execute
    validate_user_and_reservation
    check_reservation_status
    cancel_reservation
    update_restaurant_seats
    send_cancellation_email
  rescue StandardError => e
    { error: e.message, support_contact: 'support@example.com' }
  end
  private
  def validate_user_and_reservation
    @user = User.find_by(id: user_id)
    @reservation = Reservation.find_by(id: reservation_id)
    raise 'Invalid user or reservation' unless @user && @reservation
  end
  def check_reservation_status
    raise 'Cannot cancel completed or past reservation' if @reservation.status == 'completed' || @reservation.status == 'past'
  end
  def cancel_reservation
    @reservation.update!(status: 'cancelled')
    { message: 'Reservation cancelled successfully' }
  end
  def update_restaurant_seats
    @restaurant = Restaurant.find_by(id: @reservation.restaurant_id)
    @restaurant.update(total_seats: @restaurant.total_seats + @reservation.number_of_seats)
  end
  def send_cancellation_email
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, reservation: @reservation).cancellation_email.deliver_later
  end
end
# rubocop:enable Style/ClassAndModuleChildren
