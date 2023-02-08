class LocationsController < ApplicationController
    def index
        render json: Location.all
    end

    def show
        render json: Location.find(params[:id])
    end

    def get_look()
        player_location = Location.find_by(current_room: true)
        return "You are in the #{player_location.name}. #{player_location.description}"
    end

    def get_location()
        player_location = Location.find_by(current_room: true)
        return player_location.name
    end

    def reset_location()
        player_location = Location.find_by(current_room: true)
        spawn_room = Location.find_by(name: "central room")
        if (player_location != spawn_room)
            player_location.update(current_room: false)
            spawn_room.update(current_room: true)
        else
            puts "successfully reset location"
        end
    end

    def go_north()
        player_location = Location.find_by(current_room: true)
        if player_location.name == "central room"
            new_room = Location.find_by(name: "north room")
            update_current_room(player_location, new_room)
        elsif player_location.name == "south room"
            new_room = Location.find_by(name: "central room")
            update_current_room(player_location, new_room)
        else
            return "You can't go that way."
        end
    end

    def go_east()
        player_location = Location.find_by(current_room: true)
        if player_location.name == "central room"
            new_room = Location.find_by(name: "east room")
            update_current_room(player_location, new_room)
        elsif player_location.name == "west room"
            new_room = Location.find_by(name: "central room")
            update_current_room(player_location, new_room)
        else
            return "You can't go that way."
        end
    end

    def go_south()
        player_location = Location.find_by(current_room: true)
        if player_location.name == "central room"
            new_room = Location.find_by(name: "south room")
            update_current_room(player_location, new_room)
        elsif player_location.name == "north room"
            new_room = Location.find_by(name: "central room")
            update_current_room(player_location, new_room)
        else
            return "You can't go that way."
        end
    end

    def go_west()
        player_location = Location.find_by(current_room: true)
        if player_location.name == "central room"
            new_room = Location.find_by(name: "west room")
            update_current_room(player_location, new_room)
        elsif player_location.name == "east room"
            new_room = Location.find_by(name: "central room")
            update_current_room(player_location, new_room)
        else
            return "You can't go that way."
        end
    end

    private

    def update_current_room(player_location, new_room)
        player_location.update(current_room: false)
        new_room.update(current_room: true)
        return "You are in the #{new_room.name}. #{new_room.description}"
    end

end
