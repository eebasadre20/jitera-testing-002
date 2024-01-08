class Api::ReservationsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show update destroy]
  def show
    begin
      reservation_service = ReservationService::Show.new(params[:id])
      @reservation = reservation_service.execute
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end
  def update
    @reservation = ReservationService::Confirm.new(params.permit!, current_resource_owner).execute
    if @reservation.errors.any?
      @error_object = @reservation.errors.messages
      render 'api/reservations/error', status: :unprocessable_entity
    else
      render 'api/reservations/show', status: :ok
    end
  end
  def destroy
    begin
      id = params[:id]
      raise 'Wrong format' unless id.is_a? Integer
      service = ReservationService::Delete.new(id)
      message = service.execute
      render json: { status: 200, message: message }
    rescue => e
      render json: { status: 400, message: e.message }
    end
  end
end
