class FoodCategory < ApplicationRecord
  has_many :user_food_preferences, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
