# rubocop:disable Style/ClassAndModuleChildren
class RestaurantService::Search
  attr_accessor :params, :records
  def initialize(params, _current_user = nil)
    @params = params
    @records = Restaurant
  end
  def execute
    search_by_name
    if records.blank?
      raise ActiveRecord::RecordNotFound, 'Restaurant not found'
    end
    records
  end
  def search_by_name
    return if params[:restaurant_name].blank?
    @records = Restaurant.where('name like ?', "%#{params[:restaurant_name]}%")
  end
end
# rubocop:enable Style/ClassAndModuleChildren
