class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name 
      t.string :email
      t.text :comments
      t.timestamps
    end
  end
end
