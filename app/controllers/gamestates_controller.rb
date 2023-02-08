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
        when "help"
            output = help()
        when "look"
            output = LocationsController.new.get_location()
        when /go north|north|n|go east|east|e|go south|south|s|go west|west|w/
            output = LocationsController.new.handle_move(input)
        else
            output = "I don't understand \"#{input}\"."
        end

        current_room = LocationsController.new.get_location()
        gamestate = Gamestate.create(input: input, output: output, room: current_room)
        render json: { input: input, output: output, id: gamestate.id }
    end

    def destroy
        LocationsController.new.reset_location()
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end

    private

    def help
        return "Help is on the way!"
    end


end
