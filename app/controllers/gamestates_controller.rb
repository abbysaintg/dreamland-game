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
        when "cheat"
            output = cheat()
        when /^(sit|sit down)$/
            output = sit()
        when /^say (.*)/
            output = "You say #{$1}, but no one seems to hear you."
        when "look"
            output = LocationsController.new.get_look()
        when /^(walk north|walk n|go north|north|go n|n|walk east|walk e|go east|east|go e|e|walk south|walk s|go south|south|go s|s|walk west|walk w|go west|west|go w|w)$/
            output = LocationsController.new.handle_move(input)
        when /^(walk|walk |go |go)$/
            output = "Where do you want to go?"
        when /^take (.*)/
            player_location_id = LocationsController.new.get_location_id()
            output = ItemsController.new.take_item($1, player_location_id)
        when /^drop (.*)/
            player_location_id = LocationsController.new.get_location_id()
            output = ItemsController.new.drop_item($1, player_location_id)
        when /^(inventory|inv)$/
            output = ItemsController.new.get_inventory()
        else
            output = "I don't understand \"#{input}\"."
        end

        player_location_name = LocationsController.new.get_location_name()
        gamestate = Gamestate.create(input: input, output: output, room: player_location_name)
        render json: { input: input, output: output, id: gamestate.id, room: player_location_name }
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

    def sit 
        return "You've got things to do!"
    end

    def cheat
        return "The answer is 42."
    end

end
