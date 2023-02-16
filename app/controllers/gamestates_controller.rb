class GamestatesController < ApplicationController

    def index
        user = @current_user
        gamestates = user.gamestates
        render json: gamestates
    end

    def create
        input = params[:input]
        current_location_id = Gamestate.last.location_id

        case input
        when /^examine (.*)/, /^look at (.*)/
            output = ItemsController.new.examine($1, current_location_id)
        when /^(look|look around)$/
            output = LocationsController.new.get_location_desc()
        when /^search (.*)/
            output = ItemsController.new.search($1, current_location_id)
        when /^eat (.*)/
            output = ItemsController.new.eat($1, current_location_id)
        when /^drink (.*)/
            output = ItemsController.new.drink($1)
        when /^wear (.*)/
            output = ItemsController.new.wear($1, current_location_id)
        when /^remove (.*)/
            output = ItemsController.new.remove($1)
        when /^drop (.*)/
            output = ItemsController.new.drop_item($1)
        when /^(inventory|inv|i)$/
            output = ItemsController.new.get_inventory()
        when "open door"
            output = LocationsController.new.open_door()
        when "close door"
            output = LocationsController.new.close_door()
        when "open chest"
            output = LocationsController.new.open_chest()
        when /^(unlock chest|unlock chest with key)$/
            output = LocationsController.new.unlock_chest()
        when /^(take hand|take ghost|take figure)$/
            output = LocationsController.new.take_hand()
        when /^take (.*)/
            output = ItemsController.new.take_item($1, current_location_id)
        when /^(stand|stand up|get up)$/
            output = LocationsController.new.stand_up()
        when /^(walk north|walk n|go north|north|go n|n|walk east|walk e|go east|east|go e|e|walk south|walk s|go south|south|go s|s|walk west|walk w|go west|west|go w|w|go up|up|go down|down|climb up|climb down|swim north|swim south|swim east|swim west|swim n|swim e|swim s|swim w|swim down|swim d|swim up|swim u)$/
            output = LocationsController.new.handle_move(input)
        when /^(affix gem|place gem|affix ruby|place ruby|place ruby on archway|place gem on archway|place ruby in archway|place gem in archway|fix archway)$/
            output = LocationsController.new.affix_ruby()
        when /^(fix door|put doorknob in door|affix doorknob|place doorknob)$/
            output = LocationsController.new.fix_door()
        when /^(push rug|move rug|roll rug)$/
            output = LocationsController.new.move_rug()
        when /^(give jar|give pickles|give pickles to wizard|give jar to wizard|give wizard jar|give wizard pickles)$/
            output = ItemsController.new.give_pickles(current_location_id)
        when /^(draw water|fill bucket|draw bucket)$/
            output = ItemsController.new.draw_water(current_location_id)
        when /^(douse fire|put water on fire|dump bucket on fire|dump water on fire|throw water on fire|put out fire)$/
            output = LocationsController.new.douse_fire()
        when /^(kill|kill bird|kill sparrow|hit bird|hit sparrow)$/
            output = ItemsController.new.kill_bird(current_location_id)
        when "read book"
            output = ItemsController.new.examine(book, current_location_id)
        when /^teleport (.*)/
            output = LocationsController.new.teleport($1)
        when /^say (.*)/
            output = "You say \"#{$1}\", but no one seems to be listening."
        when /^(walk|walk |go |go)$/
            output = "Where would you like to go?"
        when /^(swim)$/
            output = "Where would you like to swim?"
        when /^(sleep|go to sleep)$/
            output = "You try to fall asleep, but are unsuccessful."
        when /^(wake|wake up)$/
            output = "You try to wake up, but are unsuccessful."
        when /^(sit|sit down)$/
            output = "You can't sit down right now. You've got things to do!"
        when "unlock"
            output = "What would you like to unlock?"
        when "open"
            output = "What would you like to open?"
        when /^(cheat|cheats)$/
            output = "Come on now, that's hardly called for."
        when "help"
            output = "If you don't know what to do next, you might want to try the basics: LOOK, EXAMINE, INVENTORY, TAKE, PLACE, GIVE, SEARCH, FIX and WEAR. At anytime you may type RESET to restart the game."
        else
            output = "I don't understand \"#{input}\"."
        end

        updated_location_id = LocationsController.new.get_location_id()
        user_id = @current_user.id
        gamestate = Gamestate.create(input: input, output: output, location_id: updated_location_id, user_id: user_id)
        render json: { input: input, output: output, id: gamestate.id, location_id: updated_location_id, user_id: user_id }
    end

    def destroy
        LocationsController.new.reset_locations()
        ItemsController.new.reset_inventory()
        Gamestate.where("id > 3").destroy_all
        head :no_content
    end
end
