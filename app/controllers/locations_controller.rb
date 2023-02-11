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
        return "#{current_location.name}: #{current_location.id}. #{current_location.desc} #{current_location.exits} #{location_items}"
    end

    def get_location_id()
        current_location = Location.find_by(current_location: true)
        return current_location.id
    end

    def get_location(id)
        location = Location.find(id)
        return location
    end

    def reset_locations()
        kitchen = Location.find(50)
        kitchen.update(desc: "A warm kitchen, sunlight streams in through the windows. A table and chairs fit neatly into a corner. A wide woven rug is here.")
        kitchen.update(exits: "The living room is to the west.")
        current_location = Location.find_by(current_location: true)
        spawn_room = Location.find(5)
        current_location.update(current_location: false)
        spawn_room.update(current_location: true)
    end

    def move_rug(current_location_id)
        if current_location_id == 50
            kitchen = Location.find(50)
            kitchen.update(desc: "A warm kitchen, sunlight streams in through the windows. A table and chairs fit neatly into a corner. The rug has been pushed to the side, revealing a wooden trap down in the floor.")
            kitchen.update(exits: "The living room is to the west, a trap door leads down.")
            return "You move the rug and find a trapdoor beneath."
        else
            return "There is no rug here to move."
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
        when /^(go up|up|climb up|u)$/
            go_up()
        when /^(go down|down|climb down|d)$/
            go_down()
        end
    end

    # def unlock()
    #     key = Item.find_by(name: "key")
    #     current_location = Location.find_by(current_location: true)
    #     exits = current_location.exits
    #     if key.location_id == 3 && exits.include?("locked")
    #         exits.gsub!("a locked", "an unlocked")
    #         current_location.update(exits: exits)
    #         if current_location.name == "west room"
    #             central = Location.find_by(name: "central room")
    #             central_exits = central.exits
    #             central_exits.gsub!("a locked", "an unlocked")
    #             central.update(exits: central_exits)
    #         elsif current_location.name == "central room"
    #             west = Location.find_by(name: "west room")
    #             west_exits = west.exits
    #             west_exits.gsub!("a locked", "an unlocked")
    #             west.update(exits: west_exits)
    #         end
    #         return "You unlock the door with the key."
    #     elsif key.location_id == 3 && !exits.include?("locked")
    #         return "There is nothing to unlock here."
    #     else
    #         return "You don't have a key to unlock this door."
    #     end
    # end

    # def lock()
    #     key = Item.find_by(name: "key")
    #     current_location = Location.find_by(current_location: true)
    #     exits = current_location.exits
    #     if key.location_id == 3 && exits.include?("unlocked")
    #         exits.gsub!("an unlocked", "a locked")
    #         current_location.update(exits: exits)
    #         if current_location.name == "west room"
    #             central = Location.find_by(name: "central room")
    #             central_exits = central.exits
    #             central_exits.gsub!("an unlocked", "a locked")
    #             central.update(exits: central_exits)
    #         elsif current_location.name == "central room"
    #             west = Location.find_by(name: "west room")
    #             west_exits = west.exits
    #             west_exits.gsub!("an unlocked", "a locked")
    #             west.update(exits: west_exits)
    #         end
    #         return "You lock the door with the key."
    #     elsif key.location_id == 3 && !exits.include?("unlocked")
    #         return "There is nothing to lock here."
    #     else
    #         return "You don't have a key to lock this door."
    #     end
    # end

    # def reset_locks()
    #     central = Location.find_by(name: "central room")
    #     west = Location.find_by(name: "west room")
    #     central_exits = central.exits
    #     west_exits = west.exits
    #     central_exits.gsub!("an unlocked", "a locked")
    #     west_exits.gsub!("an unlocked", "a locked")
    #     central.update(exits: central_exits)
    #     west.update(exits: west_exits)
    # end

    # private

    def go_north()
        current_location = Location.find_by(current_location: true)
        location_map = {
            8 => 7,
            11 => 10,
            12 => 11,
            15 => 14,
            16 => 15,
            17 => 16,
            18 => 17,
            22 => 23,
            23 => 24,
            24 => 25,
            25 => 26,
            39 => 40,
            40 => 41,
            43 => 39,
            48 => 43,
            52 => 46,
            53 => 48,
            56 => 52,
            57 => 54,
            60 => 57,
            63 => 58,
            66 => 61,
            67 => 62,
            69 => 64,
            72 => 67,
            77 => 72,
            75 => 70,
            79 => 74,
            76 => 71,
            81 => 76,
            82 => 77,
            83 => 80,
            84 => 83,
            85 => 84,
        }
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the north")
            return "The door to the north is locked."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_east
        current_location = Location.find_by(current_location: true)
        location_map = {
            5 => 6,
            6 => 7,
            9 => 8,
            8 => 10,
            12 => 13,
            13 => 14,
            14 => 38,
            26 => 27,
            22 => 21,
            21 => 20,
            20 => 19,
            19 => 18,
            16 => 47,
            38 => 39,
            43 => 44,
            44 => 45,
            45 => 46,
            47 => 48,
            48 => 49,
            49 => 50,
            53 => 54,
            54 => 55,
            55 => 56,
            58 => 59,
            59 => 60,
            60 => 61,
            61 => 62,
            63 => 64,
            64 => 65,
            65 => 66,
            68 => 69,
            70 => 71,
            74 => 75,
            79 => 80,
            81 => 82,
            85 => 86,
            86 => 87,
            87 => 88,
        }
        if current_location.exits.include?("a locked door to the east")
            return "The door to the east is locked."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_south()
        current_location = Location.find_by(current_location: true)
        location_map = {
            7 => 8,
            10 => 11,
            11 => 12,
            14 => 15,
            15 => 16,
            16 => 17,
            17 => 18,
            23 => 22,
            24 => 23,
            25 => 24,
            26 => 25,
            39 => 43,
            40 => 39,
            41 => 40,
            43 => 48,
            46 => 52,
            48 => 53,
            52 => 56,
            54 => 57,
            57 => 60,
            58 => 63,
            61 => 66,
            62 => 67,
            64 => 69,
            67 => 72,
            68 => 73,
            71 => 76,
            72 => 77,
            70 => 75,
            73 => 78,
            74 => 79,
            76 => 81,
            77 => 82,
            80 => 83,
            83 => 84,
            84 => 85,
        }
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the south")
            return "The door to the south is locked."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_west()
        current_location = Location.find_by(current_location: true)
        location_map = {
            6 => 5,
            7 => 6,
            8 => 9,
            10 => 8,
            12 => 27,
            13 => 12,
            14 => 13,
            27 => 26,
            18 => 19,
            19 => 20,
            20 => 21,
            21 => 22,
            39 => 38,
            44 => 43,
            45 => 44,
            46 => 45,
            47 => 16,
            48 => 47,
            49 => 48,
            50 => 49,
            56 => 55,
            55 => 54,
            54 => 53,
            59 => 58,
            60 => 59,
            61 => 60,
            62 => 61,
            64 => 63,
            65 => 64,
            66 => 65,
            69 => 68,
            71 => 70,
            75 => 74,
            80 => 79,
            82 => 81,
        }
        current_location = Location.find_by(current_location: true)
        if current_location.exits.include?("a locked door to the west")
            return "The door to the west is locked."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_up
        current_location = Location.find_by(current_location: true)
        location_map = { 41 => 42, 33 => 32, 51 => 50 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            update_current_location(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_down
        current_location = Location.find_by(current_location: true)
        location_map = { 42 => 41, 32 => 33, 50 => 51 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
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
