class AddUserIdToGamestates < ActiveRecord::Migration[7.0]
    def change
        change_table :gamestates do |t|
            t.belongs_to :user, null: false, foreign_key: true
        end 
    end
end
