class ItemsController < ApplicationController
    def index
        render json: Item.all
    end

    def show
        render json: Item.find(params[:id])
    end

    def examine_item(input, current_location_id)
        item = Item.find_by(name: input)
        if item && item.location_id == current_location_id
            return item.desc
        else 
            return "I don't see a #{input} here."
        end
    end

    def get_inventory
        items = Item.where(location_id: 3)
        if items.empty?
            return "Your bag is empty."
        else
            player_inventory = items.map(&:name).join(", ")
            return "Your bag is holding: #{player_inventory}"
        end
    end

    def get_location_items(location)
        items = Item.where(location_id: location.id)
        location_items = items.map(&:name)
        if location_items.count == 1
            return "There is a #{location_items.first} here."
        elsif location_items.count > 1
            last_item = location_items.pop
            return "There is #{location_items.join(", ")} and a #{last_item} here."
        else
            return ""
        end
    end

    # what about items with two words, need to be able to reference the main word i.e. bottle or cake
    def take_item(item, current_location_id)
        cake = Item.find_by(name: "slice of cake")
        if item.include?("cake") && cake.location_id == current_location_id
            return "You can't put a slice of cake in your bag!"
        else 
            item_to_take = Item.find_by(name: item)
            if item_to_take && item_to_take.location_id == current_location_id
                item_to_take.update(location_id: 3)
                return "You pick up the #{item_to_take.name} and put it in your bag."
            else
                return "I don't see that here."
            end
        end
    end

    def drop_item(item, current_location_id)
        item_to_drop = Item.find_by(name: item)
        if item_to_drop && item_to_drop.location_id == 3
            item_to_drop.update(location_id: current_location_id)
            return "You drop the #{item_to_drop.name}."
        else
            return "You don't have a #{item} in your bag."
        end
    end

    def reset_inventory
        towel = Item.find_by(name: "towel")
        towel.update(location_id: 3)
        key = Item.find_by(name: "key")
        key.update(location_id: 4)
        book = Item.find_by(name: "book")
        book.update(location_id: 5)
        hat = Item.find_by(name: "hat")
        hat.update(location_id: 6)
        bottle = Item.find_by(name: "water bottle")
        bottle.update(location_id: 7)
        cake = Item.find_by(name: "slice of cake")
        cake.update(location_id: 8)
    end

    def eat_cake(current_location_id)
        cake = Item.find_by(name: "slice of cake")
        if current_location_id == cake.location_id
            cake.update(location_id: 1)
            return "You eat the cake and lick the frosting off your fingers. Delicious."
        else 
            return "While cake sounds delicious right now, you don't see any."
        end
    end

    def drink_water(current_location_id)
        water = Item.find_by(name: "water bottle")
        if current_location_id == water.location_id || water.location_id == 3
            water.update(location_id: 1)
            Item.create(location_id: 3, name: "empty bottle", desc: "An empty bottle of water.")
            return "You drink the water."
        else 
            return "You don't see any water around."
        end
    end

    def wear_hat(current_location_id)
        hat = Item.find_by(name: "hat")
        if current_location_id == hat.location_id
            hat.update(location_id: 2)
            return "You put the hat on. It's warm and stylish."
        else 
            return "You don't see a hat here."
        end
    end

end


# 1 - the void
# 2 - body
# 3 - inventory
# 4 - starting room
# 5 - north room 
# 6 - east room 
# 7 - south room 
# 8 - west room 