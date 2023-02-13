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
            output = "The answer is 42."
        when /^(sit|sit down)$/
            output = "You can't sit down right now. You've got things to do!"
        when /^say (.*)/
            output = "You say \"#{$1}\", but no one seems to be listening."
        when /^examine (.*)/
            output = ItemsController.new.examine($1, current_location_id)
        when /^search (.*)/
            output = ItemsController.new.search($1, current_location_id)
        when /^eat (.*)/
            output = ItemsController.new.eat($1, current_location_id)
        when /^drink (.*)/
            output = ItemsController.new.drink($1)
        when /^wear (.*)/
            output = ItemsController.new.wear($1, current_location_id)
        when /^remove (.*)/
            output = ItemsController.new.remove($1, current_location_id)
        when /^take (.*)/
            output = ItemsController.new.take_item($1, current_location_id)
        when /^drop (.*)/
            output = ItemsController.new.drop_item($1, current_location_id)
        when /^(inventory|inv|i)$/
            output = ItemsController.new.get_inventory()
        when /^(walk|walk |go |go)$/
            output = "Where would you like to go?"
        when "look"
            output = LocationsController.new.get_location_desc()
        when /^(walk north|walk n|go north|north|go n|n|walk east|walk e|go east|east|go e|e|walk south|walk s|go south|south|go s|s|walk west|walk w|go west|west|go w|w|go up|up|go down|down|climb up|climb down)$/
            output = LocationsController.new.handle_move(input)
        when "unlock door"
            output = LocationsController.new.unlock()
        when "open chest"
            output = LocationsController.new.open_chest(current_location_id)
        when "unlock chest"
            output = LocationsController.new.unlock_chest(current_location_id)
        when "unlock" 
            output = "What would you like to unlock?"
        when "open"
            output = "What would you like to open?"
        when /^(fix door|put doorknob in door)$/
            output = LocationsController.new.fix_door()
        when /^(push rug|move rug)$/
            output = LocationsController.new.move_rug(current_location_id)
        when /^(give jar|give pickles|give pickles to wizard|give jar to wizard)$/
            output = ItemsController.new.give_pickles(current_location_id)
        when /^(draw water|fill bucket|draw bucket)$/
            output = ItemsController.new.draw_water(current_location_id)
        when /^(douse fire|put water on fire|dump bucket on fire|dump water on fire|throw water on fire|)$/
            output = LocationsController.new.douse_fire()
        when /^teleport (.*)/
            output = LocationsController.new.teleport($1)
        else
            output = "I don't understand \"#{input}\"."
        end

        updated_location_id = LocationsController.new.get_location_id()
        gamestate = Gamestate.create(input: input, output: output, location_id: updated_location_id)
        render json: { input: input, output: output, id: gamestate.id, location_id: updated_location_id }
    end

    def destroy
        LocationsController.new.reset_locations()
        ItemsController.new.reset_inventory()
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end

    private

    def help
        return "Help is on the way!"
    end

end
