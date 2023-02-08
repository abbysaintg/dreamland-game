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
        
        gamestate = Gamestate.create( input: input, output: output )
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
