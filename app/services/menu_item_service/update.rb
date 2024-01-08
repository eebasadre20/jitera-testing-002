# rubocop:disable Style/ClassAndModuleChildren
class MenuItemService::Update
  attr_accessor :params, :menu_item
  def initialize(params)
    @params = params
    @menu_item = MenuItem.find_by(id: params[:id])
  end
  def execute
    validate_menu_item_id
    update_menu_item_details
    confirmation_message
  end
  def validate_menu_item_id
    raise 'Invalid menu item id' if @menu_item.nil?
  end
  def update_menu_item_details
    @menu_item.update(
      name: params[:name],
      description: params[:description],
      price: params[:price],
      ingredients: params[:ingredients],
      recipe: params[:recipe]
    )
  end
  def confirmation_message
    'Menu item updated successfully'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
