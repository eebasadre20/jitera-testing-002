require 'bcrypt'

module Users
  class PasswordEncryptionService
    def self.encrypt_password(password)
      begin
        password_salt = BCrypt::Engine.generate_salt
        password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        return password_hash
      rescue => e
        # Handle encryption errors
        raise "Password encryption failed: #{e.message}"
      end
    end
  end
end
