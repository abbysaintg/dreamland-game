class AddInputColumnToGamestates < ActiveRecord::Migration[7.0]
  def change
    add_column :gamestates, :input, :string
  end
end
