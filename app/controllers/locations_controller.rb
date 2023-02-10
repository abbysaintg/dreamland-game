class LocationsController < ApplicationController
    def index
        render json: Location.all
    end

    def show
        render json: Location.find(params[:id])
    end

    def get_location_desc()
        current_location = Location.find_by(current_location: true)
        location_items = ItemsController.new.get_location_items(current_location)
        return "You are in the #{current_location.name}. #{current_location.desc} #{current_location.exits} #{location_items}"
        # if location_items.blank?
        #     return "You are in the #{current_location.name}. #{current_location.desc} #{current_location.exits}"
        # elsif location_items.split(" and a ").count >= 1
        #     return "You are in the #{current_location.name}. #{current_location.desc} #{current_location.exits} #{location_items}"
        # else
        #     return "You are in the #{current_location.name}. #{current_location.desc} #{current_location.exits} #{location_items}"
        # end
    end

    def get_location_id()
        current_location = Location.find_by(current_location: true)
        return current_location.id
    end

    def get_location(id)
        location = Location.find(id)
        return location
    end 

    def reset_location()
        current_location = Location.find_by(current_location: true)
        spawn_room = Location.find_by(name: "central room")
        if (current_location != spawn_room)
            current_location.update(current_location: false)
            spawn_room.update(current_location: true)
        else
            return "error: location reset"
        end
    end

    def handle_move(input)
        case input
        when /^(walk north|walk n|go north|north|go n|n)$/
            go_north()
        when /^(walk east|walk e|go east|east|go e|e)$/
            go_east()
        when /^(walk south|walk s|go south|south|go s|s)$/
            go_south()
        when /^(walk west|walk w|go west|west|go w|w)$/
            go_west()
        end
    end


    def unlock()
        key = Item.find_by(name: "key")
        current_location = Location.find_by(current_location: true)
        exits = current_location.exits
        if key.location_id == 3 && exits.include?("locked")
            exits.gsub!("a locked", "an unlocked")
            current_location.update(exits: exits)
            if current_location.name == "west room"
                central = Location.find_by(name: "central room")
                central_exits = central.exits
                central_exits.gsub!("a locked", "an unlocked")
                central.update(exits: central_exits)
            elsif current_location.name == "central room"
                west = Location.find_by(name: "west room")
                west_exits = west.exits
                west_exits.gsub!("a locked", "an unlocked")
                west.update(exits: west_exits)
            end
            return "You unlock the door with the key."
        elsif key.location_id == 3 && !exits.include?("locked")
            return "There is nothing to unlock here."
        else
            return "You don't have a key to unlock this door."
        end 
    end

    def lock()
        key = Item.find_by(name: "key")
        current_location = Location.find_by(current_location: true)
        exits = current_location.exits
        if key.location_id == 3 && exits.include?("unlocked")
            exits.gsub!("an unlocked", "a locked")
            current_location.update(exits: exits)
            if current_location.name == "west room"
                central = Location.find_by(name: "central room")
                central_exits = central.exits
                central_exits.gsub!("an unlocked", "a locked")
                central.update(exits: central_exits)
            elsif current_location.name == "central room"
                west = Location.find_by(name: "west room")
                west_exits = west.exits
                west_exits.gsub!("an unlocked", "a locked")
                west.update(exits: west_exits)
            end
            return "You lock the door with the key."
        elsif key.location_id == 3 && !exits.include?("unlocked")
            return "There is nothing to lock here."
        else
            return "You don't have a key to lock this door."
        end 
    end

    def reset_locks()
        central = Location.find_by(name: "central room")
        west = Location.find_by(name: "west room")
        central_exits = central.exits
        west_exits = west.exits
        central_exits.gsub!("an unlocked", "a locked")
        west_exits.gsub!("an unlocked", "a locked")
        central.update(exits: central_exits)
        west.update(exits: west_exits)
    end

    private

    def go_north()
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the north")
            return "The door to the north is locked."
        elsif current_location.name == "central room"
            new_location = Location.find_by(name: "north room")
            update_current_location(current_location, new_location)
        elsif current_location.name == "south room"
            new_location = Location.find_by(name: "central room")
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_east()
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the east")
            return "The door to the east is locked."
        elsif current_location.name == "central room"
            new_location = Location.find_by(name: "east room")
            update_current_location(current_location, new_location)
        elsif current_location.name == "west room"
            new_location = Location.find_by(name: "central room")
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_south()
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the south")
            return "The door to the south is locked."
        elsif current_location.name == "central room"
            new_location = Location.find_by(name: "south room")
            update_current_location(current_location, new_location)
        elsif current_location.name == "north room"
            new_location = Location.find_by(name: "central room")
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_west()
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the west")
            return "The door to the west is locked."
        elsif current_location.name == "central room"
            new_location = Location.find_by(name: "west room")
            update_current_location(current_location, new_location)
        elsif current_location.name == "east room"
            new_location = Location.find_by(name: "central room")
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def update_current_location(current_location, new_location)
        current_location.update(current_location: false)
        new_location.update(current_location: true)
        new_location.update(visited: true)
        description = get_location_desc()
        return description
    end


end
