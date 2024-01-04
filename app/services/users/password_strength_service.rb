# frozen_string_literal: true

module Users
  class PasswordStrengthService
    def self.check_password_strength(password)
      return [false, 'Password must be at least 18 characters long.'] if password.length < 18
      unless password.match?(/\A(?=.*[a-zA-Z])(?=.*[0-9]).{18,}\z/)
        return [false, 'Password must contain alphanumeric characters.']
      end

      [true, '']
    end
  end
end

# Note: This service assumes that additional logic for handling the password strength check
# will be implemented elsewhere, such as in a registration service or controller.
# This service only provides the basic password strength validation logic.
