# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Create
  attr_accessor :params, :user, :restaurant, :reservation
  def initialize(params, user)
    @params = params
    @user = user
  end
  def execute
    validate_params
    find_user_and_restaurant
    check_seats_availability
    create_reservation
    send_confirmation_notification
  end
  private
  def validate_params
    raise 'Invalid params' unless params[:user_id] && params[:restaurant_id] && params[:number_of_seats] && params[:date_time]
  end
  def find_user_and_restaurant
    @user = User.find_by(id: params[:user_id])
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
    raise 'User or Restaurant not found' unless user && restaurant
  end
  def check_seats_availability
    reserved_seats = Reservation.where(restaurant_id: restaurant.id, date_time: params[:date_time]).sum(:number_of_seats)
    available_seats = restaurant.total_seats - reserved_seats
    raise 'Not enough seats available' if available_seats < params[:number_of_seats]
  end
  def create_reservation
    @reservation = Reservation.create(
      user_id: user.id,
      restaurant_id: restaurant.id,
      number_of_seats: params[:number_of_seats],
      date_time: params[:date_time],
      special_requests: params[:special_requests]
    )
  end
  def send_confirmation_notification
    # Here should be the code to send a confirmation notification to the user
    # with the reservation details and reservation code.
    # As it's not specified how the notification should be sent (email, SMS, etc.),
    # I leave this method empty.
  end
end
# rubocop:enable Style/ClassAndModuleChildren
