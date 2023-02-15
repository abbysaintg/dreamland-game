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
        return "#{current_location.desc} #{current_location.exits} #{location_items}"
    end

    def get_location_id()
        current_location = Location.find_by(current_location: true)
        return current_location.id
    end

    def get_location(id)
        location = Location.find(id)
        return location
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
        when /^(swim north|swim n)$/
            swim_north()
        when /^(swim east|swim e)$/
            swim_east()
        when /^(swim south|swim s)$/
            swim_south()
        when /^(swim west|swim w)$/
            swim_west()
        when /^(swim down|swim d)$/
            swim_down()
        when /^(swim up|swim u)$/
            swim_up()
        end
    end

    def take_hand()
        current_location = Location.find_by(current_location: true)
        bedroom = Location.find(4)
        dream_crossroads = Location.find(89)
        if current_location.id == 4
            bedroom.update(current_location: false)
            dream_crossroads.update(current_location: true)
            return "You take the extended hand of the ghost. In a flash it has transported you through time and space. Stars and inky darkness keep you aloft in an endless expanse. You have no idea where you are. Maybe you should take a \"look\" around."
        else
            return "I don't understand."
        end 
    end

    def stand_up()
        current_location = Location.find_by(current_location: true)
        top_of_mountain_v1 = Location.find(90)
        top_of_mountain_v2 = Location.find(5)
        if current_location.id == 4
            return "You get out of bed. The ghost offers his hand to you, waiting."
        elsif current_location.id == 90
            location_items = ItemsController.new.get_location_items(top_of_mountain_v2)
            top_of_mountain_v1.update(current_location: false)
            top_of_mountain_v2.update(current_location: true)
            return "Ignoring a feeling of vertigo, you get to your feet. #{top_of_mountain_v2.desc} #{top_of_mountain_v2.exits} #{location_items}"
        else 
            return "You are already standing!"
        end
    end

    def affix_ruby()
        current_location = Location.find_by(current_location: true)
        archway = Location.find(10)
        archway_item = ItemsController.new.find_item(24)
        ruby = ItemsController.new.find_item(4)
        if current_location.id == 10 && ruby.location_id == 3
            ruby.update(location_id: 1)
            archway.update(desc: "A stone archway stands tall here, seemingly carved straight out of the mountains. Seven gemstones have been affixed to the archway's pillars.")
            archway_item.update(desc: "A beautiful stone archway, seven gemstones have been embedded into the stone.")
            return "You place the ruby into the slot on the archway. The forcefield shivers and sputters and then dies out completely, allowing you entry into the valley."
        elsif current_location.id == 10
            return "You don't have a gem affix to the archway."
        else 
            return "I'm sorry, what?"
        end
    end

    def unlock_chest()
        current_location = Location.find_by(current_location: true)
        shipwreck = Location.find(33)
        key = ItemsController.new.find_item(3)
        if current_location == shipwreck && shipwreck.desc.include?("a locked wooden chest") && key.location_id == 3
            shipwreck.update(desc: "You hold your breath, swimming at the bottom of the lake. It's murky and eerily quiet, cold water surrounds you. There's an old sunken shipwreck here, deteriorating at the bottom of the lake. You can see an unlocked but closed wooden chest nestled in the bowels of the ship.")
            return "You unlock the chest."
        elsif current_location == shipwreck && shipwreck.desc.include?("a locked wooden chest")
            return "You do not have a key to unlock this chest."
        elsif current_location == shipwreck && shipwreck.desc.include?("an unlocked wooden chest")
            return "The chest is already unlocked, but remains closed."
        else
            return "I don't see a chest here."
        end
    end

    def open_chest()
        current_location = Location.find_by(current_location: true)
        shipwreck = Location.find(33)
        key = ItemsController.new.find_item(3)
        if current_location == shipwreck && shipwreck.desc.include?("opened")
            return "The chest is already opened."
        elsif current_location == shipwreck && shipwreck.desc.include?("a locked wooden chest") && key.location_id == 3
            return "The chest is locked. You'll need to unlock it first!"
        elsif current_location == shipwreck && shipwreck.desc.include?("a locked wooden chest")
            return "The chest is locked and you do not have the right key to unlock it."
        elsif current_location == shipwreck && shipwreck.desc.include?("an unlocked but closed wooden chest")
            shipwreck.update(desc:"You hold your breath, swimming at the bottom of the lake. It's murky and eerily quiet, cold water surrounds you. There's an old sunken shipwreck here, deteriorating at the bottom of the lake. You can see an opened wooden chest nestled in the bowels of the ship. There is a golden doorknob inside the chest.",)
            return "You open the chest. There is a golden doorknob inside."
        else
            return "I don't see a chest here."
        end
    end

    def fix_door()
        current_location = Location.find_by(current_location: true)
        doorknob = ItemsController.new.find_item(5)
        if current_location.id == 48 && doorknob.location_id == 3 && current_location.exits.include?("missing a doorknob")
            current_location.update(exits: "The entrace to the cottage is directly east. Towards the north you spot the tower, to the south the wide forest resides, and another path winds westward through the trees.")
            doorknob.update(location_id: 1)
            return "You fit the doorknob into the door. The door is now fixed."
        else
            return "You don't have the means to do that."
        end
    end

    def open_door()
        current_location = Location.find_by(current_location: true)
        dream_crossroads = Location.find(89)
        top_of_mountain_v1 = Location.find(90)
        compass = ItemsController.new.find_item(7)
        if compass.location_id == 3 && current_location.id == 89
            dream_crossroads.update(current_location: false)
            top_of_mountain_v1.update(current_location: true)
            return "With great difficulty, you manage to float towards the door and wrench it open. Light bursts forth from the open doorway, and then the world seems to tilt on its axis and you fall through it. You keep falling and FALLing and FALLING, andYOUAREGOINGTO--you fall to the ground with a thud."
        elsif compass.location_id != 3 && current_location.id == 89
            return "That compass looks like it might come in handy, I should probably take that first."
        elsif current_location.desc.include?("door")
            return "You open the door."
        else 
            return "There's no door here to open."
        end
    end

    def close_door()
        current_location = Location.find_by(current_location: true)
        if current_location.desc.include?("door")
            return "You close the door."
        else 
            return "There's no door here to close."
        end
    end

    def move_rug()
        current_location = Location.find_by(current_location: true)
        kitchen = Location.find(50)
        if current_location.id == 50 && kitchen.desc.include?("trapdoor")
            kitchen.update(desc: "A warm kitchen, sunlight streams in through the windows. A wooden table and two chairs fit neatly into a corner. A woven rug covers the floor.")
            return "You move the rug back to cover the trapdoor."
        elsif current_location.id == 50 && !kitchen.desc.include?("trapdoor")
            kitchen.update(desc: "A warm kitchen, sunlight streams in through the windows. A table and chairs fit neatly into a corner. The rug has been pushed to the side, revealing a wooden trapdoor in the floor.")
            return "You move the rug and find a trapdoor beneath."
        else
            return "There is no rug here to move."
        end
    end

    def douse_fire()
        current_location = Location.find_by(current_location: true)
        cottage_interior = Location.find(49)
        wizard_room = Location.find(41)
        forest_spirit_location = Location.find(57)
        empty_bucket = ItemsController.new.find_item(12)
        bucket_of_water = ItemsController.new.find_item(15)
        if current_location.id == 49 || current_location.id == 41
            if bucket_of_water.location_id == 3 && current_location.desc.include?("crackles")
                bucket_of_water.update(location_id: 1)
                empty_bucket.update(location_id: 3)
                if current_location == cottage_interior
                    cottage_interior.update(desc: "The inside of the cottage is warm and inviting. The living room is filled with an overstuffed sofa and a worn rocking chair. The hearth is damp, the fire dead.")
                elsif current_location == wizard_room
                    wizard_room.update(desc: "The main room of the tower is filled to the brim with magical artifacts, books, potions, dried herbs, and plants you don't recognize. The hearth is damp, the fire dead.")
                end
                if !wizard_room.desc.include?("crackles") && !cottage_interior.desc.include?("crackles")
                    forest_spirit_location.update(desc: "The forest looms above you. It's dark and menacing. You'd rather not go into it. A cute tree spirit dances in the breeze around you.")
                else
                    forest_spirit_location.update(desc: "The forest looms above you. It's dark and menacing. You'd rather not go into it. The tree spirit seems calmer now, but still pissed at you. It spits pine needles at your face.")
                end
                return "You toss the bucket of water on the fire. It hisses, steams, and eventually goes out."
            elsif bucket_of_water.location_id == 3 && current_location.desc.include?("dead")
                return "The fire is out. Adding more water would be pointless."
            else
                return "You do not have water to douse the fire with."
            end
        end
    end

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
            65 => 60,
            67 => 62,
            69 => 64,
            72 => 67,
            73 => 68,
            77 => 72,
            75 => 70,
            78 => 73,
            79 => 74,
            76 => 71,
            81 => 76,
            82 => 77,
            83 => 80,
            84 => 83,
            19 => 37,
            20 => 36,
            21 => 35,
            28 => 27,
            29 => 12,
            30 => 13,
            31 => 28,
            32 => 29,
            34 => 30,
            35 => 16,
            36 => 32,
            37 => 34
        }
        if current_location.desc.include?("a grumpy wizard")
            return "You try to go into the tower but the grumpy wizard shouts obscenities at you."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "north"
            update_current_location(direction, new_location)
        elsif [58, 59, 61, 62, 64, 66, 68, 70, 71, 74, 80].include?(current_location.id) && !location_map.key?(current_location.id)
            maze_reset(current_location)
        else
            return "You can't go that way."
        end
    end

    def go_east()
        current_location = Location.find_by(current_location: true)
        location_map = {
            5 => 6,
            6 => 7,
            9 => 8,
            8 => 10,
            12 => 13,
            13 => 14,
            14 => 38,
            16 => 47,
            19 => 18,
            20 => 19,
            21 => 20,
            22 => 21,
            26 => 27,
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
            88 => 91,
            25 => 28,
            28 => 29,
            29 => 30,
            30 => 15,
            24 => 31,
            31 => 32,
            32 => 34,
            34 => 16,
            23 => 35,
            35 => 36,
            36 => 37,
            37 => 17
        }
        if current_location.exits.include?("doorknob")
            return "The door is missing a doorknob, so you can't open it. Perhaps you could try finding the missing doorknob?"
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "east"
            update_current_location(direction, new_location)
        elsif [62, 67, 72, 77, 82, 66, 71, 76, 75, 80, 78, 73, 69].include?(current_location.id) && !location_map.key?(current_location.id)
            maze_reset(current_location)
        else
            return "You can't go that way."
        end
    end

    def go_south()
        current_location = Location.find_by(current_location: true)
        archway = Location.find(10)
        wizard_room = Location.find(41)
        cottage_interior = Location.find(49)
        tree_spirit_location = Location.find(57)
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
            60 => 65,
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
            27 => 28,
            12 => 29,
            13 => 30,
            28 => 31,
            29 => 32,
            30 => 34,
            31 => 35,
            32 => 36,
            34 => 37,
            35 => 21,
            36 => 20,
            37 => 19 
        }
        if current_location.id == 10 && archway.desc.include?("blocking")
            return "A forcefield blocks your entry into the valley."
        elsif current_location.id == 57 && tree_spirit_location.desc.include?("pine needles")
            new_location = Location.find(32)
            new_location.update(current_location: true)
            current_location.update(current_location: false)
            return "You try to cross into the forest, but the tree spirit still seems to be pissed at you. It grows to the size of a giant, picks you up, and chucks you into across the valley where you land with a splash in the lake."
        elsif current_location.id == 57 && (wizard_room.desc.include?("crackles") || cottage_interior.desc.include?("crackles"))
            new_location = Location.find(56)
            new_location.update(current_location: true)
            current_location.update(current_location: false)
            return "You try to cross into the forest, but the tree spirit screams bloody murder at you, shouting something about you burning the flesh of its kin. It grows to the size a giant, picks you up, and chucks you up the hill, where you land with a thud in the middle of the vegetable garden."
        elsif current_location.exits.include?("locked")
            return "The door to the south is locked."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "south"
            update_current_location(direction, new_location)
        elsif [59, 61, 63, 65, 66, 69, 75, 78, 79, 81, 82].include?(current_location.id) && !location_map.key?(current_location.id)
            maze_reset(current_location)
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
            18 => 19,
            19 => 20,
            20 => 21,
            21 => 22,
            27 => 26,
            38 => 14,
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
            15 => 30,
            30 => 29,
            29 => 28,
            28 => 25,
            16 => 34,
            34 => 32,
            32 => 31,
            31 => 24,
            17 => 37,
            37 => 36,
            36 => 35,
            35 => 23
        }
        lantern = ItemsController.new.find_item(1)
        if current_location.id == 8 && (lantern.location_id != 3)
            return "The cave looks too dark to enter without a light source."
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "west"
            update_current_location(direction, new_location)
        elsif [58, 63, 68, 73, 78, 74, 79, 70, 76, 81, 77, 72, 67].include?(current_location.id) && !location_map.key?(current_location.id)
            maze_reset(current_location)
        else
            return "You can't go that way."
        end
    end

    def go_up()
        current_location = Location.find_by(current_location: true)
        location_map = { 41 => 42, 33 => 32, 51 => 50, 33 => 32 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "up"
            update_current_location(direction, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_down()
        current_location = Location.find_by(current_location: true)
        kitchen = Location.find(50)
        location_map = { 42 => 41, 32 => 33, 32 => 33 }
        if current_location == kitchen && kitchen.desc.include?("trapdoor")
            new_location = Location.find(51)
            direction = "down"
            update_current_location(direction, new_location)
        elsif current_location.id == 91
            new_location = Location.find(92)
            current_location.update(current_location: false)
            new_location.update(current_location: true)
            description = get_location_desc()
            return "You fall down, down, down. And then you awake with a jolt! #{description}"
        elsif location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "down"
            update_current_location(direction, new_location)
        else
            return "You can't go that way."
        end
    end

    def swim_north()
        current_location = Location.find_by(current_location: true)
        location_map = {             
            19 => 37,
            20 => 36,
            21 => 35,
            28 => 27,
            29 => 12,
            30 => 13,
            31 => 28,
            32 => 29,
            34 => 30,
            35 => 16,
            36 => 32,
            37 => 34 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "north"
            update_current_location_swimming(direction, new_location)
        else
            return "You can't swim that way."
        end
    end
    
    def swim_east()
        current_location = Location.find_by(current_location: true)
        location_map = {             
            25 => 28,
            28 => 29,
            29 => 30,
            30 => 15,
            24 => 31,
            31 => 32,
            32 => 34,
            34 => 16,
            23 => 35,
            35 => 36,
            36 => 37,
            37 => 17 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "east"
            update_current_location_swimming(direction, new_location)
        else
            return "You can't swim that way."
        end
    end

    def swim_south()
        current_location = Location.find_by(current_location: true)
        location_map = {             
            27 => 28,
            12 => 29,
            13 => 30,
            28 => 31,
            29 => 32,
            30 => 34,
            31 => 35,
            32 => 36,
            34 => 37,
            35 => 21,
            36 => 20,
            37 => 19 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "south"
            update_current_location_swimming(direction, new_location)
        else
            return "You can't swim that way."
        end
    end

    def swim_west()
        current_location = Location.find_by(current_location: true)
        location_map = {             
            15 => 30,
            30 => 29,
            29 => 28,
            28 => 25,
            16 => 34,
            34 => 32,
            32 => 31,
            31 => 24,
            17 => 37,
            37 => 36,
            36 => 35,
            35 => 23 }
        if location_map.key?(current_location.id)
            new_location = Location.find(location_map[current_location.id])
            direction = "west"
            update_current_location_swimming(direction, new_location)
        else
            return "You can't swim that way."
        end
    end

    def swim_up()
        current_location = Location.find_by(current_location: true)
        if current_location.id == 33
            new_location = Location.find(32)
            direction = "up"
            update_current_location_swimming(direction, new_location)
        else
            return "You can't swim that way."
        end
    end

    def swim_down()
        current_location = Location.find_by(current_location: true)
        if current_location.id == 32
            new_location = Location.find(33)
            direction = "down"
            update_current_location_swimming(direction, new_location)
        else
            return "You can't swim that way."
        end
    end

    def teleport(input)
        current_location = Location.find_by(current_location: true)
        current_location.update(current_location: false)
        new_location = Location.find(input)
        new_location.update(current_location: true)
        location_items = ItemsController.new.get_location_items(new_location)
        return "You teleport to the #{new_location.name}. #{new_location.desc} #{new_location.exits} #{location_items}"
    end

    def update_current_location(direction, new_location)
        current_location = Location.find_by(current_location: true)
        if new_location.name.include?("lake")
            return "There's water in the way, you'll need to swim."
        elsif new_location.name.include?("river")
            current_location.update(current_location: false)
            new_location.update(current_location: true)
            description = get_location_desc()
            return "You row #{direction}. #{description}"
        else
            current_location.update(current_location: false)
            new_location.update(current_location: true)
            description = get_location_desc()
            return "You walk #{direction}. #{description}"
        end
    end

    def update_current_location_swimming(direction, new_location)
        current_location = Location.find_by(current_location: true)
        swimsuit = ItemsController.new.find_item(6)
        if swimsuit.location_id != 2
            return "You must be wearing a swimsuit to go swimming!"
        else 
            current_location.update(current_location: false)
            new_location.update(current_location: true)
            description = get_location_desc()
            return "You swim #{direction}. #{description}"
        end

    end

    def maze_reset(current_location)
        forest_entrance  = Location.find(60)
        current_location.update(current_location: false)
        forest_entrance.update(current_location: true)
        return "You take a wrong turn and get lost in the woods. You somehow appear back at the entrance to the forest. #{forest_entrance.desc} #{forest_entrance.exits}"
    end

    def reset_locations()
        Location.update_all(current_location: false)
        bird_location = Location.find(18)
        bird_location.update(desc: "The water looks inviting, crystal clear and cool. A sparrow flies about happily, enjoying life.")
        kitchen = Location.find(50)
        kitchen.update(desc: "A warm kitchen, sunlight streams in through the windows. A wooden table and two chairs fit neatly into a corner. A woven rug covers the floor.")
        shipwreck = Location.find(33)
        shipwreck.update(desc: "You hold your breath, swimming at the bottom of the lake. It's murky and eerily quiet here, cold water surrounds you. There's an old sunken shipwreck here, deteriorating into the mud. You can see a locked wooden chest nestled in the bowels of the ship.")
        cottage_exterior = Location.find(48)
        cottage_exterior.update(exits: "The entrance to the cottage is directly east, but the door is missing a doorknob. Towards the north you spot the tower, to the south the wide forest resides, and another path winds westward through the trees.")
        cottage_interior = Location.find(49)
        cottage_interior.update(desc: "The inside of the cottage is warm and inviting. The living room is filled with an overstuffed sofa and a worn rocking chair. A fire crackles in a stone hearth.")
        tower_entrance = Location.find(40)
        tower_entrance.update(desc: "The stone tower stands tall, rising like a beacon in the forest. It's made from rough-hewn stone blocks, and the windows have been intricately created from colorful stained glass. There is a grumpy wizard here, rocking in a chair by the door. He hums to himself and eyes you suspiciously.")
        wizard_room = Location.find(41)
        wizard_room.update(desc: "The windowless room is filled to the brim with magical artifacts, books, potions, dried herbs, and plants you don't recognize. A large fire crackles in the hearth, casting the room in a warm glow.")
        bedroom = Location.find(4)
        bedroom.update(current_location: true)
    end

end
