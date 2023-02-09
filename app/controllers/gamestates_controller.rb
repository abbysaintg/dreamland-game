class GamestatesController < ApplicationController

    def index
        render json: Gamestate.all
    end

    def create
        input = params[:input]
        current_location_id = Gamestate.last.location_id

        case input
        when "help"
            output = help()
        when "cheat"
            output = cheat()
        when /^(sit|sit down)$/
            output = sit()
        when "jump"
            output = jump()
        when /^say (.*)/
            output = say($1)
        when /^(walk|walk |go |go)$/
            output = where()
        when "look"
            output = LocationsController.new.get_location_desc()
        when /^(walk north|walk n|go north|north|go n|n|walk east|walk e|go east|east|go e|e|walk south|walk s|go south|south|go s|s|walk west|walk w|go west|west|go w|w)$/
            output = LocationsController.new.handle_move(input)
        when /^take (.*)/
            output = ItemsController.new.take_item($1, current_location_id)
        when /^drop (.*)/
            output = ItemsController.new.drop_item($1, current_location_id)
        when /^(inventory|inv|i)$/
            output = ItemsController.new.get_inventory()
        when /^unlock door/
            output = LocationsController.new.unlock()
        when /^lock door/
            output = LocationsController.new.lock()
        when "test"
            output = "testing"
            # room = LocationsController.new.get_location(6)
            # output = ItemsController.new.get_location_items(room)
        else
            output = error(input)
        end

        updated_location_id = LocationsController.new.get_location_id()
        gamestate = Gamestate.create(input: input, output: output, location_id: updated_location_id)
        render json: { input: input, output: output, id: gamestate.id, location_id: updated_location_id }
    end

    def destroy
        LocationsController.new.reset_location()
        LocationsController.new.reset_locks()
        ItemsController.new.reset_inventory()
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end

    private

    def help
        return "Help is on the way!"
    end

    def cheat
        return "The answer is 42."
    end

    def sit
        return "You can't sit down right now. You've got things to do!"
    end

    def jump
        return "You jump for joy!"
    end

    def say(input)
        return "You say \"#{input}\", but no one seems to hear you."
    end

    def where
        return "Where do you want to go?"
    end

    def error(input)
        return "I don't understand \"#{input}\"."
    end
end
