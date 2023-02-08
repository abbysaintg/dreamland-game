class LocationsController < ApplicationController

    def index
        render json: Location.all
    end

    def show
        render json: Location.find(params[:id])
    end

    def get_location()
        current_room = Location.find_by(current_room: true)
        return "You are in the #{current_room.name}."
    end

    def reset_location
        current_room = Location.find_by(current_room: true)
        spawn_room = Location.find_by(name: "central room")
        current_room.update(current_room: false)
        spawn_room.update(current_room: true)
    end

    def handle_move(input)
        case input
        when /go north|north|n/
            go_north()
        when /go east|east|e/
            go_east()
        when /go south|south|s/
            go_south()
        when /go west|west|w/
            go_west()
        end
    end

    private

    def go_north()
        current_room = Location.find_by(current_room: true)
        if current_room.name == "central room"
            new_room = Location.find_by(name: "north room")
            update_current_room(current_room, new_room)
            return "You go north."
        elsif current_room.name == "south room"
            new_room = Location.find_by(name: "central room")
            update_current_room(current_room, new_room)
            return "You go north."
        else
            return "You can't go that way."
        end
    end

    def go_east()
        current_room = Location.find_by(current_room: true)
        if current_room.name == "central room"
            new_room = Location.find_by(name: "east room")
            update_current_room(current_room, new_room)
            return "You go east."
        elsif current_room.name == "west room"
            new_room = Location.find_by(name: "central room")
            update_current_room(current_room, new_room)
            return "You go east."
        else
            return "You can't go that way."
        end
    end

    def go_south()
        current_room = Location.find_by(current_room: true)
        if current_room.name == "central room"
            new_room = Location.find_by(name: "south room")
            update_current_room(current_room, new_room)
            return "You go south."
        elsif current_room.name == "north room"
            new_room = Location.find_by(name: "central room")
            update_current_room(current_room, new_room)
            return "You go south."
        else
            return "You can't go that way."
        end
    end

    def go_west()
        current_room = Location.find_by(current_room: true)
        if current_room.name == "central room"
            new_room = Location.find_by(name: "west room")
            update_current_room(current_room, new_room)
            return "You go west."
        elsif current_room.name == "east room"
            new_room = Location.find_by(name: "central room")
            update_current_room(current_room, new_room)
            return "You go west."
        else
            return "You can't go that way."
        end
    end

    def update_current_room(current_room, new_room)
        current_room.update(current_room: false)
        new_room.update(current_room: true)
    end
end
