class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
    	t.string :source
    	t.text :description
    	t.string :type
    	t.float :amount	
    	t.integer :user_id
    	t.datetime :entry_date
      t.timestamps null: false
    end
  end
end
