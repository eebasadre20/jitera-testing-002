class User < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :user_food_preferences, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :searches, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
