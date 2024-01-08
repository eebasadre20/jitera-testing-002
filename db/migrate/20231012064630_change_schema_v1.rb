class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :users, comment: 'Table to store user information' do |t|
      t.string :username

      t.string :password

      t.timestamps null: false
    end

    create_table :reservations, comment: 'Table to store reservation information' do |t|
      t.integer :seats_reserved

      t.string :reservation_code

      t.string :restaurant_name

      t.text :special_requests

      t.integer :reservation_status, default: 0

      t.datetime :reservation_date_time

      t.timestamps null: false
    end

    add_reference :reservations, :user, foreign_key: true
  end
end
