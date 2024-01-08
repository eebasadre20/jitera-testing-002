# rubocop:disable Style/ClassAndModuleChildren
class RestaurantService::Update
  attr_accessor :params, :restaurant
  def initialize(params)
    @params = params
    @restaurant = Restaurant.find_by(id: params[:id])
  end
  def execute
    validate_restaurant_id
    update_restaurant_details
    confirmation_message
  end
  def validate_restaurant_id
    raise 'Invalid restaurant id' if @restaurant.nil?
  end
  def update_restaurant_details
    @restaurant.update(
      name: params[:name],
      address: params[:address],
      phone_number: params[:phone_number],
      cuisine_type: params[:cuisine_type],
      hours_of_operation: params[:hours_of_operation],
      user_ratings: params[:user_ratings]
    )
  end
  def confirmation_message
    'Restaurant details updated successfully'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
