class LocationsController < ApplicationController
    def index
        render json: Location.all
    end

    def show
        render json: Location.find(params[:id])
    end

    def handle_move(input, current_room)
        case input
        when "go north"
            go_north(current_room)
        when "go east"
            go_east(current_room)
        when "go south"
            go_south(current_room)
        when "go west"
            go_west(current_room)
        end 
    end

    private

    def go_north(current_room)
        if current_room == "central room"
            current_room = "north room"
            return "You go north."
        elsif current_room == "south room"
            current_room = "central room"
            return "You go north."
        else
            current_room = current_room
            return "You can't go that way."
        end
    end

    def go_east(current_room)
        if current_room == "central room"
            current_room = "east room"
            return "You go east."
        elsif current_room == "west room"
            current_room = "central room"
            return "You go east."
        else
            return "You can't go that way."
        end
    end

    def go_south(current_room)
        if current_room == "central room"
            current_room = "south room"
            return "You go south."
        elsif current_room == "north room"
            current_room = "central room"
            return "You go south."
        else
            return "You can't go that way."
        end
    end

    def go_west(current_room)
        if current_room == "central room"
            current_room = "west room"
            return "You go west."
        elsif current_room == "east room"
            current_room = "central room"
            return "You go west."
        else
            return "You can't go that way."
        end
    end


end
