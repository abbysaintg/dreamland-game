class AddExitsColumnToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :exits, :string
  end
end
