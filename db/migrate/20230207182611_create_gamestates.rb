class CreateGamestates < ActiveRecord::Migration[7.0]
  def change
    create_table :gamestates do |t|
      t.string :output
    end
  end
end
