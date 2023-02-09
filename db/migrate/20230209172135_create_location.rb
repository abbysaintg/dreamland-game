class CreateLocation < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :desc
      t.boolean :current_location
      t.boolean :visited 
    end
  end
end
