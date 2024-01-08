# rubocop:disable Style/ClassAndModuleChildren
class RestaurantSearchService
  attr_accessor :params, :user, :records
  def initialize(params, user)
    @params = params
    @user = user
    @records = Restaurant
  end
  def execute
    validate_user
    validate_inputs
    search_by_location
    search_by_food_category
    filter_by_date
    filter_by_budget_range
    filter_by_number_of_seats
    map_view
    save_search
    paginate
  end
  private
  def validate_user
    raise 'User not authenticated' unless User.exists?(id: user.id)
  end
  def validate_inputs
    raise 'Invalid location' unless Location.exists?(name: params[:location])
    raise 'Invalid food category' unless FoodCategory.exists?(name: params[:food_category])
    raise 'Invalid date' if params[:date].blank? || params[:date] < Date.today
    raise 'Invalid budget range' if params[:budget_range].blank? || params[:budget_range] < 0
    raise 'Invalid number of seats' if params[:number_of_seats].blank? || params[:number_of_seats] < 0
    raise 'Invalid map view option' unless [true, false].include?(params[:map_view])
  end
  def search_by_location
    @records = records.where(location: params[:location])
  end
  def search_by_food_category
    @records = records.joins(:food_categories).where(food_categories: { name: params[:food_category] })
  end
  def filter_by_date
    @records = records.where('date >= ?', params[:date])
  end
  def filter_by_budget_range
    @records = records.where('budget_range <= ?', params[:budget_range])
  end
  def filter_by_number_of_seats
    @records = records.where('available_seats >= ?', params[:number_of_seats])
  end
  def map_view
    # Implement map view logic here
  end
  def save_search
    Search.create!(
      user_id: user.id,
      search_criteria: params,
      search_date: DateTime.now
    )
  end
  def paginate
    @records = records.page(params[:page] || 1).per(params[:per_page] || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
