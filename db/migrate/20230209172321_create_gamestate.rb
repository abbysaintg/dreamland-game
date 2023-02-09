class CreateGamestate < ActiveRecord::Migration[7.0]
  def change
    create_table :gamestates do |t|
      t.string :input
      t.string :output
      t.belongs_to :location, null: false, foreign_key: true
    end
  end
end
