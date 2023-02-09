class ItemsController < ApplicationController
    def index
        render json: Item.all
    end

    def show
        render json: Item.find(params[:id])
    end

    def get_inventory
        items = Item.where(location_id: 1)
        if items.empty?
            return "Your bag is empty."
        else
            player_inventory = items.map(&:name).join(", ")
            return "Your bag is holding: #{player_inventory}"
        end
    end

    def get_location_items(location)
        items = Item.where(location_id: location.id)
        location_items = items.map(&:name).join(" and a ")
        return location_items
    end

    def take_item(item, current_location_id)
        item_to_take = Item.find_by(name: item)
        if item_to_take.location_id == current_location_id
            item_to_take.update(location_id: 1)
            return "You pick up the #{item_to_take.name} and put it in your bag."
        else
            return "I don't see that here."
        end
    end

    def drop_item(item, current_location_id)
        item_to_drop = Item.find_by(name: item)
        if item_to_drop && item_to_drop.location_id == 1
            item_to_drop.update(location_id: current_location_id)
            return "You get the #{item_to_drop.name} out of your bag and drop it."
        else
            return "You don't have a #{item} in your bag."
        end
    end

    def reset_inventory
        towel = Item.find_by(name: "towel")
        towel.update(location_id: 1)
        key = Item.find_by(name: "key")
        key.update(location_id: 2)
        book = Item.find_by(name: "book")
        book.update(location_id: 3)
        hat = Item.find_by(name: "hat")
        hat.update(location_id: 4)
        bottle = Item.find_by(name: "water bottle")
        bottle.update(location_id: 5)
        cake = Item.find_by(name: "cake")
        cake.update(location_id: 6)
    end
end
