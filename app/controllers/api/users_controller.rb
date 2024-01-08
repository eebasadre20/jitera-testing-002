class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show]
  def show
    @user = User.find_by!('users.id = ?', params[:id])
  end
  def reservations
    @reservations = ReservationService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @reservations.total_pages
  end
end
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show]
  def show
    @user = User.find_by!('users.id = ?', params[:id])
  end
  def reservations
    @reservations = ReservationService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @reservations.total_pages
  end
end
