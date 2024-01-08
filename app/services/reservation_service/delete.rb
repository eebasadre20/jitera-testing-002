# rubocop:disable Style/ClassAndModuleChildren
class ReservationService::Delete
  attr_accessor :id
  def initialize(id)
    @id = id
  end
  def execute
    validate_id
    delete_reservation
  end
  def validate_id
    raise 'Invalid ID' unless Reservation.exists?(id)
  end
  def delete_reservation
    Reservation.find(id).destroy
    'Reservation deleted successfully'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
