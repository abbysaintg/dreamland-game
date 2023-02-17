class ItemsController < ApplicationController
    def index
        render json: Item.all
    end

    def show
        render json: Item.find(params[:id])
    end

    def find_item_by_name(name)
        item = Item.find_by(name: name)
        return item
    end

    def find_item(id)
        item = Item.find(id)
        return item
    end

    def examine(input, current_location_id)
        item = Item.where("name LIKE ?", "%#{input}%").where("location_id = ? OR location_id = ?", current_location_id, 3).first
        if item.location_id == current_location_id || item.location_id == 3
            return item.desc
        else
            return "That isn't something you can examine."
        end
    end

    def search(input, current_location_id)
        cave = LocationsController.new.get_location(9)
        shipwreck = LocationsController.new.get_location(33)
        basin = Item.find_by(name: "basin")
        ruby = Item.find_by(name: "ruby")
        doorknob = Item.find_by(name: "doorknob")
        if input.include?("basin") && ruby.location_id == 1 && current_location_id == 9
            ruby.update(location_id: 3)
            basin.update(location_id: 1)
            cave.update(desc: "The weak glow from your lantern barely lights your nearby surroundings, let alone the entire expanse of the wide cave. Strange whispers and the rustling of unseen things echo from the depths, making the hairs on the back of your neck stand on end.")
            return "You stick your hand into the inky black liquid and pull out a blood red gemstone. The basin and the black liquid disappear in flash of smoke, leaving you with pristine ruby."
        elsif input.include?("chest") && shipwreck.desc.include?("doorknob") && current_location_id == 33
            doorknob.update(location_id: 3)
            shipwreck.update(desc: "You hold your breath, swimming at the bottom of the lake. It's murky and eerily quiet here, cold water surrounds you. There's an old sunken shipwreck here, deteriorating into the mud. You can see an opened wooden chest nestled in the bowels of the ship. The chest is empty.")
            return "You take the doorknob out of the chest."
        elsif input.include?("chest") && (shipwreck.desc.include?("locked") || shipwreck.desc.include?("closed")) && current_location_id == 33
            return "You need to open the chest before you can search it."
        elsif input.include?("chest") && shipwreck.desc.include?("opened") && !shipwreck.desc.include?("doorknob") && current_location_id == 33
            return "The chest is empty."
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
            return "You are holding: #{holding_inventory}. You are not wearing anything."
        elsif holding_items.empty? 
            wearing_inventory = wearing_items.map(&:name).join(", ")
            return "You are not holding anything. You are wearing: #{wearing_inventory}."
        else 
            wearing_inventory = wearing_items.map(&:name).join(", ")
            holding_inventory = holding_items.map(&:name).join(", ")
            return "You are holding: #{holding_inventory}. You are wearing: #{wearing_inventory}."
        end
    end

    def get_location_items(location)
        exclude_item_ids = [2, 5, 14, 16, 17, 18,19, 21, 22, 23, 24]
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

    def take_item(input, current_location_id)
        item_to_take = Item.find_by(name: input)
        current_location = LocationsController.new.get_location(current_location_id)
        shipwreck = LocationsController.new.get_location(33)
        doorknob = Item.find_by(name: "doorknob")
        empty_bucket = Item.find_by(name: "empty bucket")
        if (input.include?("basin") && current_location_id == 9) || (input.include?("arch") && current_location_id == 10) || (input.include?("chest") && current_location_id == 33)
            return "That's much too large to take with you."
        elsif (input.include?("wizard") && current_location_id == 40) || (input.include?("bird") && current_location_id == 18) || (input.include?("sparrow") && current_location_id == 18)
            return "You can't take the #{input}. That would be kidnapping!"
        elsif input.include?("doorknob") && shipwreck.desc.include?("doorknob") && current_location_id == 33
            doorknob.update(location_id: 3)
            shipwreck.update(desc: "You hold your breath, swimming at the bottom of the lake. It's murky and eerily quiet here, cold water surrounds you. There's an old sunken shipwreck here, deteriorating into the mud. You can see an opened wooden chest nestled in the bowels of the ship. The chest is empty.")
            return "You take the doorknob out of the chest."
        elsif input.include?("doorknob") && !shipwreck.desc.include?("doorknob") && current_location_id == 33 
            return "I don't see that here."
        elsif input.include?("bucket") && empty_bucket.location_id == current_location_id
            return "You take the empty bucket."
        elsif item_to_take && item_to_take.location_id == current_location_id
            item_to_take.update(location_id: 3)
            return "You take the #{item_to_take.name}."
        elsif current_location.desc.include?("#{input}")
            return "You can't take the #{input} with you."
        else 
            return "I don't see that here."
        end
    end

    def drop_item(input)
        item_to_drop = Item.where("name LIKE ?", "%#{input}%").where("location_id = ? OR location_id = ?", 2, 3).first
        if item_to_drop
            return "You should probably hold onto the #{item_to_drop.name} for now."
        else 
            return "You aren't holding a #{input}."
        end
        # if item_to_drop == compass
        #     return "You should probably hold onto the compass."
        # elsif item_to_drop == lantern && current_location_id == 9
        #     return "You grip the lantern tightly and refuse to drop it. You need to light to see by!"
        # elsif item_to_drop && item_to_drop.location_id == 3
        #     item_to_drop.update(location_id: current_location_id)
        #     return "You drop the #{item_to_drop.name}."
        # elsif item_to_drop && item_to_drop.location_id == 2
        #     item_to_drop.update(location_id: current_location_id)
        #     return "You take the #{item_to_drop.name} off and drop it to the ground."
        # else
        #     return "You don't have a #{item}."
        # end
    end

    def eat(input, current_location_id)
        cake = Item.find_by(name: "slice of cake")
        if input.include?("cake") && (cake.location_id == current_location_id || cake.location_id == 3)
            cake.update(location_id: 1)
            return "You eat the cake and lick the frosting off your fingers. Delicious."
        elsif input.include?("cake") 
            return "While cake sounds delicious right now, you don't see any."
        else 
            return "I don't think you'd want to eat that."
        end
    end
    
    def wear(input, current_location_id)
        item_to_wear = Item.find_by(name: input)
        hat = Item.find_by(name: "hat")
        swimsuit = Item.find_by(name: "swimsuit")
        pajamas = Item.find_by(name: "pajamas")
        if item_to_wear == hat && (hat.location_id == 3 || hat.location_id == current_location_id)
            hat.update(location_id: 2)
            return "You put on the hat. It's warm and stylish."
        elsif item_to_wear == swimsuit && (swimsuit.location_id == 3 || swimsuit.location_id == current_location_id) && pajamas.location_id == 2
            swimsuit.update(location_id: 2)
            pajamas.update(location_id: 3)
            return "You put the swimsuit on. You hope you don't run into the person who owns it, that would be awkward."
        elsif item_to_wear == pajamas && (pajamas.location_id == 3 || pajamas.location_id == current_location_id) && swimsuit.location_id == 2
            swimsuit.update(location_id: 3)
            pajamas.update(location_id: 2)
            return "You put your pajamas on. Comfy!"
        elsif item_to_wear == swimsuit && (swimsuit.location_id == 3 || swimsuit.location_id == current_location_id) && pajamas.location_id != 2
            swimsuit.update(location_id: 2)
            return "You put the swimsuit on. You hope you don't run into the person who owns it, that would be awkward."
        elsif item_to_wear == pajamas && (pajamas.location_id == 3 || pajamas.location_id == current_location_id) && swimsuit.location_id != 2
            pajamas.update(location_id: 2)
            return "You put your pajamas on. Comfy!"
        else
            return "You can't wear that."
        end
    end

    def remove(input)
        item_to_remove = Item.find_by(name: input)
        if item_to_remove && item_to_remove.location_id == 2
            item_to_remove.update(location_id: 3)
            return "You take off the #{item_to_remove.name}."
        else 
            return "You aren't wearing that."
        end
    end


    def give_pickles(current_location_id)
        tower_entrance = LocationsController.new.get_location(40)
        pickles = Item.find_by(name: "jar of pickles")
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
        empty_bucket = Item.find_by(name: "empty bucket")
        bucket_of_water = Item.find_by(name: "bucket of water") 
        if bucket_of_water.location_id == 3
            return "The bucket is already filled with water."
        elsif empty_bucket.location_id == 3 && current_location_id == 52
            empty_bucket.update(location_id: 1)
            bucket_of_water.update(location_id: 3)
            return "Using the empty bucket you draw water from the well."
        elsif current_location_id == 52
            return "You don't have a bucket to draw water with."
        end
    end

    def drink(input)
        empty_bucket = Item.find_by(name: "empty bucket")
        bucket_of_water = Item.find_by(name: "bucket of water") 
        if input.include?("water") && bucket_of_water.location_id == 3
            bucket_of_water.update(location_id: 1)
            empty_bucket.update(location_id: 3)
            return "You drain the water from the bucket with one big slurp."
        elsif input.include?("water") 
            return "You don't have any water to drink."
        else 
            return "I don't think you'd want to drink that."
        end 
    end

    def kill_bird(current_location_id)
        bird_location = LocationsController.new.get_location(18)
        bird = Item.find_by(name: "sparrow bird")
        bird_ghost = Item.find_by(name: "ghost of a sparrow bird")
        if current_location_id == bird.location_id
            bird.update(location_id: 1)
            bird_ghost.update(location_id: 18)
            bird_location.update(desc: "The water looks inviting, crystal clear and cool. A tiny bird ghost sits here, looking sad.")
            return "You smack the bird and it dies, pitifully. Only its ghost remains, and it looks up at you sadly."
        else 
            return "You don't see anything here you'd want to kill."
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
        swimsuit = Item.find_by(name: "swimsuit")
        swimsuit.update(location_id: 45)
        compass = Item.find_by(name: "compass")
        compass.update(location_id: 89)
        hat = Item.find_by(name: "hat")
        hat.update(location_id: 5)
        cake = Item.find_by(name: "slice of cake")
        cake.update(location_id: 55)
        towel = Item.find_by(name: "towel")
        towel.update(location_id: 19)
        book = Item.find_by(name: "book")
        book.update(location_id: 41)
        bucket_of_water = Item.find_by(name: "bucket of water")
        bucket_of_water.update(location_id: 1)
        empty_bucket = Item.find_by(name: "empty bucket")
        empty_bucket.update(location_id: 42)
        pickles = Item.find_by(name: "jar of pickles")
        pickles.update(location_id: 51)
        bird = Item.find_by(name: "sparrow bird")
        bird.update(location_id: 18)
        bird_ghost = Item.find_by(name: "ghost of a sparrow bird")
        bird_ghost.update(location_id: 1)
        basin = Item.find_by(name: "basin")
        basin.update(location_id: 9)
        archway = Item.find_by(name: "archway")
        archway.update(desc: "A beautiful stone archway, six gemstones have been placed on the archway, but it's missing a seventh. A forcefield hums around it.")
    end
end
