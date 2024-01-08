class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  enum reservation_status: %w[confirmed pending canceled], _suffix: true
  enum status: %w[confirmed pending canceled completed cancelled], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
