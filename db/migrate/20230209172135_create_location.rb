class CreateLocation < ActiveRecord::Migration[7.0]
    def change
        create_table :locations do |t|
            t.string :name
            t.string :desc
            t.string :exits
            t.boolean :current_location
        end
    end
end
