class ItemsController < ApplicationController
    def index
        render json: Item.all
    end

    def show
        render json: Item.find(params[:id])
    end

    def get_inventory
        items = Item.where(in_inventory: true)
        if items.empty?
          return "Your bag is empty."
        else
          player_inventory = items.map(&:name).join(", ")
          return "Your bag is holding: #{player_inventory}"
        end
    end

    def take_item(item, player_location_id) 
        item_to_take = Item.find_by(name: item)
        if item_to_take && item_to_take.location_id == player_location_id && item_to_take.in_inventory == false 
            item_to_take.update(location_id: 1)
            item_to_take.update(in_inventory: true)
            return "You pick up the #{item_to_take.name} and put it in your bag."
        else
             return "I don't see that here."
        end 
    end

    # def take_item(item, player_location) 

    # end

end
