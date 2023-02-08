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
            output = LocationsController.new.get_look()
        when "north"
            output = LocationsController.new.go_north()
        when "east"
            output = LocationsController.new.go_east()
        when "south"
            output = LocationsController.new.go_south()
        when "west"
            output = LocationsController.new.go_west()
        else
            output = "I don't understand \"#{input}\"."
        end

        player_location = LocationsController.new.get_location()
        gamestate = Gamestate.create(input: input, output: output, room: player_location)
        render json: { input: input, output: output, id: gamestate.id, room: player_location }
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
