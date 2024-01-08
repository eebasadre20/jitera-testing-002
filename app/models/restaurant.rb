class Restaurant < ApplicationRecord
  has_many :reservations, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
