# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Index
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = Reservation
  end
  def execute
    validate_user_id
    get_reservations
    sort_reservations
    format_reservations
    paginate
  end
  def validate_user_id
    return if params.dig(:reservations, :user_id).blank?
    @user = User.find_by(id: params.dig(:reservations, :user_id))
    raise 'Invalid user_id' if @user.nil?
  end
  def get_reservations
    @records = if records.is_a?(Class)
                 Reservation.where('user_id = ?', params.dig(:reservations, :user_id))
               else
                 records.or(Reservation.where('user_id = ?', params.dig(:reservations, :user_id)))
               end
  end
  def sort_reservations
    return if records.blank?
    @records = records.order('reservations.reservation_date_time desc')
  end
  def format_reservations
    @records = records.map do |reservation|
      {
        reservation_date_time: reservation.reservation_date_time,
        restaurant_name: reservation.restaurant_name,
        seats_reserved: reservation.seats_reserved,
        reservation_status: reservation.reservation_status,
        reservation_code: reservation.reservation_code
      }
    end
  end
  def paginate
    @records = Reservation.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
