class UserFoodPreference < ApplicationRecord
  belongs_to :user
  belongs_to :food_category

  # validations

  # end for validations

  class << self
  end
end
