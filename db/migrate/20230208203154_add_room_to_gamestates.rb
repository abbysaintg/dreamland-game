class AddRoomToGamestates < ActiveRecord::Migration[7.0]
  def change
    add_column :gamestates, :room, :string
  end
end
