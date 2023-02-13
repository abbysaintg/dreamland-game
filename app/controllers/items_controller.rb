class ItemsController < ApplicationController
    def index
        render json: Item.all
    end

    def show
        render json: Item.find(params[:id])
    end

    def examine(input, current_location_id)
        item = Item.find_by(name: input)
        pickles = Item.find_by(name: "jar of pickles")
        if item && item.location_id == current_location_id
            return item.desc
        elsif input.include?("jar") || input.include?("pickles")
            return pickles.desc
        else
            return "That isn't something you can examine."
        end
    end

    def search(input, current_location_id)
        item = Item.find_by(name: input)
        basin = Item.find_by(name: "basin")
        ruby = Item.find_by(name: "ruby")
        if item = basin && ruby.location_id != 3
            ruby.update(location_id: 3)
            return "You stick your hand into the inky black liquid and pull out a blood red ruby, dripping black."
        elsif item = basin && ruby.location_id == 3
            return "You've already searched the basin."
        else
            return "That isn't something you can search."
        end
    end

    def get_inventory
        holding_items = Item.where(location_id: 3)
        wearing_items = Item.where(location_id: 2)
        if holding_items.empty? && wearing_items.empty?
            return "You are not holding or wearing anything."
        elsif wearing_items.empty? 
            holding_inventory = holding_items.map(&:name).join(", ")
            return "You are holding: #{holding_inventory}."
        elsif holding_items.empty? 
            wearing_inventory = wearing_items.map(&:name).join(", ")
            return "You are wearing: #{wearing_inventory}."
        else 
            wearing_inventory = wearing_items.map(&:name).join(", ")
            holding_inventory = holding_items.map(&:name).join(", ")
            return "You are holding: #{holding_inventory}. You are wearing: #{wearing_inventory}."
        end
    end

    def find_item_by_name(name)
        item = Item.find_by(name: name)
        return item
    end

    def find_item(id)
        item = Item.find(id)
        return item
    end

    def get_location_items(location)
        exclude_item_ids = [2, 4, 14, 16]
        items = Item.where(location_id: location.id).where.not(id: exclude_item_ids)
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

    def take_item(item, current_location_id)
        item_to_take = Item.find_by(name: item)
        basin = Item.find_by(name: "basin")
        doorknob = Item.find_by(name: "doorknob")
        wizard = Item.find_by(name: "wizard")
        pickles = Item.find_by(name: "jar of pickles")
        shipwreck = LocationsController.new.get_location(33)
        empty_bucket = Item.find_by(name: "empty bucket")
        bucket_of_water = Item.find_by(name: "bucket of water")
        if current_location_id == 9 && item_to_take = basin
            return "That's much too large to take with you."
        elsif current_location_id == 40 && item_to_take = wizard
            return "You can't take the wizard. That would be kidnapping!"
        elsif current_location_id == 51 && (item.include?("pickles") || item.include?("jar")) 
            pickles.update(location_id: 3)
            return "You take the jar of pickles."
        elsif current_location_id == 33 && shipwreck.desc.include?("doorknob") 
            doorknob.update(location_id: 3)
            shipwreck.update(desc: "You hold your breath, swimming at the bottom of the lake. It's murky and eerily quiet here, cold water surrounds you. There's an old sunken shipwreck here, deteriorating into the mud. You can see an opened wooden chest nestled in the bowels of the ship. The chest is empty.")
            return "You take the doorknob out of the chest."
        elsif empty_bucket.location_id == current_location_id && item.include?("bucket")
            empty_bucket.update(location_id: 3)
            return "You take the empty bucket."
        elsif bucket_of_water.location_id == current_location_id && item.include?("bucket")
            bucket_of_water.update(location_id: 3)
            return "You take the bucket of water."
        elsif item_to_take && item_to_take.location_id == current_location_id
            item_to_take.update(location_id: 3)
            return "You take the #{item_to_take.name}."
        else
            return "I don't see that here."
        end
    end

    def drop_item(item, current_location_id)
        item_to_drop = Item.find_by(name: item)
        lantern = Item.find_by(name: "lantern")
        if item_to_drop == lantern && current_location_id == 9
            return "You grip the lantern tightly and refuse to drop it. You need to light to see by!"
        elsif item_to_drop && item_to_drop.location_id == 3
            item_to_drop.update(location_id: current_location_id)
            return "You drop the #{item_to_drop.name}."
        elsif item_to_drop && item_to_drop.location_id == 2
            item_to_drop.update(location_id: current_location_id)
            return "You take the #{item_to_drop.name} off and drop it to the ground."
        else
            return "You don't have a #{item}."
        end
    end

    def eat(input, current_location_id)
        cake = Item.find_by(name: "slice of cake")
        if input.include?("cake") && current_location_id == cake.location_id
            cake.update(location_id: 1)
            return "You eat the cake and lick the frosting off your fingers. Delicious."
        elsif input.include?("cake") 
            return "While cake sounds delicious right now, you don't see any."
        else 
            return "I don't think you'd want to eat that."
        end
    end
    
    def wear(input, current_location_id)
        hat = Item.find_by(name: "hat")
        if input.include?("hat") && hat.location_id == 3
            hat.update(location_id: 2)
            return "You put on the hat. It's warm and stylish."
        elsif input.include?("hat") && hat.location_id == current_location_id
            hat.update(location_id: 2)
            return "You take the hat and put it on. It's warm and stylish."
        else
            return "You can't wear that."
        end
    end

    def remove(input, current_location_id)
        hat = Item.find_by(name: "hat")
        if input.include?("hat") && hat.location_id == 2
            hat.update(location_id: 3)
            return "You take off the hat and hold it."
        else 
            return "You aren't wearing that."
        end
    end


    def give_pickles(current_location_id)
        tower_entrance = LocationsController.new.get_location(40)
        pickles = Item.find(13)
        if tower_entrance.id == current_location_id && pickles.location_id == 3
            tower_entrance.update(desc: "The stone tower rises out of the earth like a beacon in the forest. It's made from rough-hewn stone blocks, and the windows have been intricately created from colorful stained glass. A wizard sits here munching happily on pickles. He ignores you completely.")
            pickles.update(location_id: 1)
            return "You offer the jar of pickles to the wizard. He giggles in delight and takes the jar, immediately opening it and slurping down a pickle."
        elsif tower_entrance.id == current_location_id
            return "You don't have any pickles to give."
        else
            return "You don't see anyone to give pickles to."
        end
    end

    def draw_water(current_location_id)
        bucket_of_water = Item.find_by(name: "bucket of water")
        empty_bucket = Item.find_by(name: "empty bucket")
        if bucket_of_water.location_id == 3
            return "The bucket is already filled with water."
        elsif empty_bucket.location_id == 3 && current_location_id == 52
            empty_bucket.update(location_id: 1)
            bucket_of_water.update(location_id: 3)
            return "Using the empty bucket you draw water from the well."
        end
    end

    def drink(input)
        bucket_of_water = Item.find_by(name: "bucket of water")
        empty_bucket = Item.find_by(name: "empty bucket")
        if input.include?("water") && bucket_of_water.location_id == 3
            bucket_of_water.update(location_id: 1)
            bucket.update(location_id: 3)
            return "You drain the water from the bucket with one big slurp."
        elsif input.include?("water") 
            return "You don't have any water to drink."
        else 
            return "I don't think you'd want to drink that."
        end 
    end

    def reset_inventory
        lantern = Item.find_by(name: "lantern")
        lantern.update(location_id: 8)
        key = Item.find_by(name: "key")
        key.update(location_id: 24)
        ruby = Item.find_by(name: "ruby")
        ruby.update(location_id: 1)
        doorknob = Item.find_by(name: "doorknob")
        doorknob.update(location_id: 33)
        hat = Item.find_by(name: "hat")
        hat.update(location_id: 5)
        cake = Item.find_by(name: "slice of cake")
        cake.update(location_id: 55)
        recipe = Item.find_by(name: "recipe")
        recipe.update(location_id: 1)
        book = Item.find_by(name: "book")
        book.update(location_id: 1)
        bucket_of_water = Item.find_by(name: "bucket of water")
        bucket_of_water.update(location_id: 1)
        empty_bucket = Item.find_by(name: "empty bucket")
        empty_bucket.update(location_id: 42)
        pickles = Item.find_by(name: "jar of pickles")
        pickles.update(location_id: 51)
    end
end