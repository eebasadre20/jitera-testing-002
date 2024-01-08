# rubocop:disable Style/ClassAndModuleChildren
class MenuItemService::Create
  attr_accessor :params, :restaurant
  def initialize(params)
    @params = params
  end
  def execute
    validate_restaurant_id
    create_menu_item
  end
  def validate_restaurant_id
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
    raise 'Invalid restaurant_id' if @restaurant.nil?
  end
  def create_menu_item
    menu_item = MenuItem.new(menu_item_params)
    menu_item.restaurant = @restaurant
    menu_item.save!
    'Menu item added successfully'
  end
  private
  def menu_item_params
    params.permit(:name, :description, :price, :ingredients, :recipe)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
