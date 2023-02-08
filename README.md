# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

class ResponsesController < ApplicationController




class GamestatesController < ApplicationController
    def index
        render json: Gamestate.all
    end

    def show
        render json: Gamestate.find(params[:id])
    end

    def create
        input = params[:input]
        case input
        when "say hello"
            output = help
        when /go north|go east|go south|go west|look/
            output = locations_controller.handle_move(input)
        else
            output = "I don't understand."
        end
    
        gamestate = Gamestate.create(output: output, location_id: 1, current_room: locations_controller.current_room)
        render json: { output: output, current_room: gamestate.current_room }
    end

    def destroy
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end

    private

    def locations_controller
        @locations_controller ||= LocationsController.new
    end

    def help
        "You say hello"
    end
end

class LocationsController < ApplicationController
    def index
        render json: Location.all
    end

    def show
        render json: Location.find(params[:id])
    end

    def handle_move(input)
        case input
        when "go north"
            go_north
        when "go east"
            go_east
        when "go south"
            go_south
        when "go west"
            go_west
        when "look"
            look
        end
    end

    private

    def go_north
        if @current_room == "central room"
            @current_room = "north room"
            return "You go north."
        elsif @current_room == "south room"
            @current_room = "central room"
            return "You go north."
        else
            return "You can't go that way."
        end
    end

    def go_east
        if @current_room == "central room"
            @current_room = "east room"
            return "You go east."
        elsif @current_room == "west room"
            @current_room = "central room"
            return "You go east."
        else
            return "You can't go that way."
        end
    end

    def go_south
        if @current_room == "central room"
            @current_room = "south room"
            return "You go south."
        elsif @current_room == "north room"
            @current_room = "central room"
            return "You go south."
        else
            return "You can't go that way."
        end
    end

    def go_west
        if @current_room == "central room"
            @current_room = "west room"
            return "You go west."
        elsif @current_room == "east room"
            @current_room = "central room"
            return "You go west."
        else
            return "You can't go that way."
        end
    end

    def look
        return "You are in the #{@current_room}."
    end
end



++++++


class GamestatesController < ApplicationController
    @@current_room = "central room"

    def index
        render json: Gamestate.all
    end

    def show
        render json: Gamestate.find(params[:id])
    end

    def create
        input = params[:input]

        case input
        when "say hello"
            output = "You say hello"
        when "look"
            output = look()
        # when /go north|go east|go south|go west/
        #     output = LocationsController.new.handle_move(input, @@current_room)
        else
            output = "I don't understand."
        end

        render json: { output: output }
        gamestate = Gamestate.create(output: output, current_room: @@current_room)
    end

    def destroy
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end

    private

    def look
        return "You are in the #{@@current_room}."
    end
end



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
            current_room = go_north(current_room)
        # when "go east"
        #     go_east
        # when "go south"
        #     go_south
        # when "go west"
        #     go_west

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

    # def go_north
    #     if @current_room == "central room"
    #         @current_room = "north room"
    #         return "You go north."
    #     elsif @current_room == "south room"
    #         @current_room = "central room"
    #         return "You go north."
    #     else
    #         @current_room = @current_room
    #         return "You can't go that way."
    #     end
    # end

    # def go_east
    #     if @current_room == "central room"
    #         @current_room = "east room"
    #         return "You go east."
    #     elsif @current_room == "west room"
    #         @current_room = "central room"
    #         return "You go east."
    #     else
    #         return "You can't go that way."
    #     end
    # end

    # def go_south
    #     if @current_room == "central room"
    #         @current_room = "south room"
    #         return "You go south."
    #     elsif @current_room == "north room"
    #         @current_room = "central room"
    #         return "You go south."
    #     else
    #         return "You can't go that way."
    #     end
    # end

    # def go_west
    #     if @current_room == "central room"
    #         @current_room = "west room"
    #         return "You go west."
    #     elsif @current_room == "east room"
    #         @current_room = "central room"
    #         return "You go west."
    #     else
    #         return "You can't go that way."
    #     end
    # end


end




class GamestatesController < ApplicationController
    @@current_room = "central room"

    def index
        render json: Gamestate.all
    end

    def show
        render json: Gamestate.find(params[:id])
    end

    def create
        input = params[:input]

        case input
        when "help"
            output = help()
        when "look"
            output = look()
        when /go north|go east|go south|go west/
            output = LocationsController.new.handle_move(input, @@current_room)
        else
            output = "I don't understand \"#{input}\"."
        end
        
        gamestate = Gamestate.create(output: { input: input, output: output })
        render json: { input: input, output: output, id: gamestate.id }
    end

    def destroy
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end

    private

    def help 
        return "Help is on the way!"
    end

    def look
        return "You are in the #{@@current_room}."
    end


end


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
