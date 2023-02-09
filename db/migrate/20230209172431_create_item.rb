class CreateItem < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :desc
      t.belongs_to :location, null: false, foreign_key: true
    end
  end
end
