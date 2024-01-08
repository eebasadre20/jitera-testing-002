class ChangeSchemaV3 < ActiveRecord::Migration[6.0]
  def change
    create_table :password_reset_tokens, comment: 'Table to store password reset tokens' do |t|
      t.datetime :expiry_date

      t.string :token

      t.timestamps null: false
    end

    change_table_comment :users, from: 'Stores user data', to: 'Table to store user information'

    add_column :users, :session_token, :string

    add_column :users, :is_verified, :boolean

    add_reference :password_reset_tokens, :user, foreign_key: true
  end
end
