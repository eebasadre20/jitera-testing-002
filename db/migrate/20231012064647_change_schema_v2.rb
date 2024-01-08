class ChangeSchemaV2 <  ActiveRecord::Migration[6.0]
def change

  create_table :credit_cards , comment: 'Table to store user's credit card information' do |t|
    
      
        
        t.string :card_number  
      
    
      
        
        t.date :expiration_date  
      
    
      
        
      
        
        t.integer :cvv  
      
    
    t.timestamps null: false
  end


  create_table :restaurants , comment: 'Stores restaurant data' do |t|
    
      
        
        t.string :name  
      
    
      
        
        t.string :operating_hours  
      
    
      
        
        t.integer :total_seats  
      
    
    t.timestamps null: false
  end


  create_table :food_categories , comment: 'Table to store different food categories' do |t|
    
      
        
        t.string :category_name  
      
    
    t.timestamps null: false
  end


  create_table :user_food_preferences , comment: 'Table to store user's preferred food categories' do |t|
    
      
        
      
        
    t.timestamps null: false
  end

change_table_comment :users, from: "Table to store user information", to: "Stores user data"
change_table_comment :reservations, from: "Table to store reservation information", to: "Stores reservation data"

  
    add_column :users, :phone_number, :string 
  


  
    add_column :reservations, :number_of_seats, :integer 
  


  
    add_column :users, :email, :string 
  


  
    add_column :users, :name, :string 
  


  
    add_column :reservations, :reservation_date, :datetime 
  


  
    add_column :reservations, :status, :integer , default: 0
  


  
    add_column :users, :is_vegan, :boolean 
  


  add_reference :reservations, :restaurant, foreign_key: true


  add_reference :credit_cards, :user, foreign_key: true


  add_reference :user_food_preferences, :food_category, foreign_key: true


  add_reference :user_food_preferences, :user, foreign_key: true


end
end