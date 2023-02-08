class AddCurrentRoomToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :current_room, :boolean
  end
end
