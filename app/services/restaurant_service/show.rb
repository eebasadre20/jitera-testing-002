# rubocop:disable Style/ClassAndModuleChildren
class RestaurantService::Show
  attr_accessor :id, :restaurant, :menu_items
  def initialize(id)
    @id = id
  end
  def execute
    validate_restaurant_id
    find_menu_items
    format_response
  end
  private
  def validate_restaurant_id
    @restaurant = Restaurant.find_by(id: id)
    raise ActiveRecord::RecordNotFound, 'Restaurant not found' unless restaurant
  end
  def find_menu_items
    @menu_items = MenuItem.where(restaurant_id: restaurant.id)
  end
  def format_response
    {
      restaurant: {
        id: restaurant.id,
        name: restaurant.name,
        address: restaurant.address,
        phone_number: restaurant.phone_number,
        cuisine_type: restaurant.cuisine_type,
        hours_of_operation: restaurant.hours_of_operation,
        user_ratings: restaurant.user_ratings
      },
      menu_items: menu_items.map do |menu_item|
        {
          id: menu_item.id,
          name: menu_item.name,
          description: menu_item.description,
          price: menu_item.price,
          ingredients: menu_item.ingredients,
          recipe: menu_item.recipe
        }
      end
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
