# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Confirm
  attr_accessor :params, :user, :reservation, :restaurant
  def initialize(params)
    @params = params
  end
  def execute
    find_user
    find_reservation
    check_user_id
    check_reservation_status
    find_restaurant
    check_operating_hours
  end
  def find_user
    @user = User.find_by(id: params[:user_id])
    raise 'User not found' unless @user
  end
  def find_reservation
    @reservation = Reservation.find_by(reservation_code: params[:reservation_code])
    raise 'Reservation not found' unless @reservation
  end
  def check_user_id
    raise 'User ID does not match reservation' unless @user.id == @reservation.user_id
  end
  def check_reservation_status
    if @reservation.status != 'confirmed'
      @reservation.update(status: 'confirmed')
    end
  end
  def find_restaurant
    @restaurant = Restaurant.find_by(id: @reservation.restaurant_id)
    raise 'Restaurant not found' unless @restaurant
  end
  def check_operating_hours
    reservation_time = @reservation.date_time
    operating_hours = @restaurant.hours_of_operation.split('-')
    start_time = Time.parse(operating_hours[0])
    end_time = Time.parse(operating_hours[1])
    if reservation_time.between?(start_time, end_time)
      'Reservation confirmed'
    else
      raise 'Reservation time is not within operating hours'
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
