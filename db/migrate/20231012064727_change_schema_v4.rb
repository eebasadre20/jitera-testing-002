class ChangeSchemaV4 < ActiveRecord::Migration[6.0]
  def change
    create_table :searches, comment: 'Table to store user search information' do |t|
      t.datetime :search_date

      t.text :search_criteria

      t.timestamps null: false
    end

    change_table_comment :restaurants, from: 'Stores restaurant data', to: 'Table to store restaurant information'
    change_table_comment :reservations, from: 'Stores reservation data', to: 'Table to store reservation information'

    add_column :reservations, :date_time, :datetime

    add_column :restaurants, :hours_of_operation, :string

    add_column :restaurants, :budget_range, :string

    add_column :restaurants, :address, :string

    add_column :restaurants, :location, :string

    add_column :restaurants, :available_seats, :integer

    add_column :restaurants, :rating, :float

    add_column :restaurants, :cuisine_type, :string

    add_column :restaurants, :phone_number, :string

    add_reference :searches, :user, foreign_key: true
  end
end
