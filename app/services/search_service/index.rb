# rubocop:disable Style/ClassAndModuleChildren
class SearchService::Index
  attr_accessor :params, :user_id, :search_criteria, :records, :query
  def initialize(params, user_id)
    @params = params
    @user_id = user_id
    @search_criteria = params[:search_criteria]
    @records = Restaurant
  end
  def execute
    validate_user
    validate_search_criteria
    perform_search
    save_search_if_no_results
    return_message
  end
  def validate_user
    user = User.find_by(id: user_id)
    raise 'User not authenticated' if user.nil?
  end
  def validate_search_criteria
    raise 'Invalid search criteria' if search_criteria.blank?
  end
  def perform_search
    @records = Restaurant.where('name like ?', "%#{search_criteria}%")
  end
  def save_search_if_no_results
    if records.blank?
      Search.create(user_id: user_id, search_criteria: search_criteria, search_date: DateTime.now)
    end
  end
  def return_message
    if records.blank?
      'No results were found, please refine your search.'
    else
      records
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
