class ResponsesController < ApplicationController
    def index
        render json: Response.all
    end

    def show
        render json: Response.find(params[:id])
    end

    def create
        input = params[:input]
        current_room = session[:current_room] || "starting room"

        case input
        when "anything"
            output = "try again smartass"
        when "say hello"
            output = say_hello
        when "sit down"
            output = sit_down
        when "stand up"
            output = stand_up
        when "help"
            output = help
        when "go north"
            current_room, output = go_north(current_room)
        when "go east"
            current_room, output = go_east(current_room)
        when "go south"
            current_room, output = go_south(current_room)
        when "go west"
            current_room, output = go_west(current_room)
        when "where am i"
            output = where_am_i(current_room)
        else
            output = "I don't understand. Type [help] for help."
        end

        session[:current_room] = current_room
        render json: { output: output }
        Response.create(output: output)
    end

    def destroy
        session[:current_room] = "starting room"
        Response.where("id > 2").destroy_all
        head :no_content
    end

    private

    def say_hello
        "You say hello."
    end

    def sit_down
        "You sit down."
    end

    def help
        "You cry out for help!"
    end

    def go_north(current_room)
        if current_room == "starting room"
            current_room = "north room"
            return current_room, "You go north. You are in the north room. There is an door to the south."
        elsif current_room == "south room"
            current_room = "starting room"
            return current_room, "You go north. You are in the starting room. There are doors to the north, east, south, and west."
        else
            return current_room, "You can't go that way."
        end
    end

    def go_east(current_room)
        if current_room == "starting room"
            current_room = "east room"
            return current_room, "You go east. You are in the east room. There is a door to the west."
        elsif current_room == "west room"
            current_room = "starting room"
            return current_room, "You go east. You are in the starting room. There are doors to the north, east, south, and west."
        else
            return current_room, "You can't go that way."
        end
    end

    def go_south(current_room)
        if current_room == "starting room"
            current_room = "south room"
            return current_room, "You go south. You are in the south room. There is a door to the north."
        elsif current_room == "north room"
            current_room = "starting room"
            return current_room, "You go south. You are in the starting room. There are doors to the north, east, south, and west."
        else
            return current_room, "You can't go that way."
        end
    end

    def go_west(current_room)
        if current_room == "starting room"
            current_room = "west room"
            return current_room, "You go west. You are in the west room. There is a door to the east."
        elsif current_room == "east room"
            current_room = "starting room"
            return current_room, "You go west. You are in the starting room. There are doors to the north, east, south, and west."
        else
            return current_room, "You can't go that way."
        end
    end

    def where_am_i(current_room)
        "You are in the #{current_room}."
    end

    # private

    # def response_params
    #     params.permit(:output)
    # end
end
