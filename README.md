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
class GamestatesController < ApplicationController

    def index
        render json: Gamestate.all
    end

    def show
        render json: Gamestate.find(params[:id])
    end

    def create
        input = params[:input]
        current_location_id = Gamestate.last.location_id
        current_gamestate_id = Gamestate.last.id

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
        # when /^take (.*)/
        #     current_location_id = LocationsController.new.get_location_id()
        #     output = ItemsController.new.take_item($1, current_location_id)
        # when /^drop (.*)/
        #     current_location_id = LocationsController.new.get_location_id()
        #     output = ItemsController.new.drop_item($1, current_location_id)
        when /^(inventory|inv)$/
            output = ItemsController.new.get_inventory(current_gamestate_id)
        when "test"
            output = ItemsController.new.get_inventory_list(current_gamestate_id)
        else
            output = error(input)
        end
        
        # player_inventory_list = ItemsController.new.get_inventory_list(current_gamestate_id)
        updated_location_id = LocationsController.new.get_location_id()
        gamestate = Gamestate.create(input: input, output: output, location_id: updated_location_id)
        render json: { input: input, output: output, id: gamestate.id, location_id: updated_location_id }
    end

    def destroy
        LocationsController.new.reset_location()
        # ItemsController.new.reset_inventory()
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
class ItemsController < ApplicationController
    def index
        render json: Item.all
    end

    def show
        render json: Item.find(params[:id])
    end

    def get_inventory
        items = Item.where(in_inventory: true)
        if items.empty?
          return "Your bag is empty."
        else
          player_inventory = items.map(&:name).join(", ")
          return "Your bag is holding: #{player_inventory}"
        end
    end

    def get_inventory_list 
        items = Item.where(in_inventory: true)
    end

    def take_item(item, player_location_id) 
        item_to_take = Item.find_by(name: item)
        if item_to_take && item_to_take.location_id == player_location_id && item_to_take.in_inventory == false 
            item_to_take.update(location_id: 1)
            item_to_take.update(in_inventory: true)
            return "You pick up the #{item_to_take.name} and put it in your bag."
        else
             return "I don't see that here."
        end 
    end

    # def take_item(item, player_location) 

    # end

end
class LocationsController < ApplicationController
    def index
        render json: Location.all
    end

    def show
        render json: Location.find(params[:id])
    end

    def get_location_desc()
        current_location = Location.find_by(current_room: true)
        return "You are in the #{current_location.name}. #{current_location.description}"
    end

    def get_location_id()
        current_location = Location.find_by(current_room: true)
        return current_location.id
    end

    def reset_location()
        current_location = Location.find_by(current_room: true)
        spawn_room = Location.find_by(name: "central room")
        if (current_location != spawn_room)
            current_location.update(current_room: false)
            spawn_room.update(current_room: true)
        else
            puts "error: location reset"
        end
    end

    def handle_move(input)
        case input
        when /^(walk north|walk n|go north|north|go n|n)$/
            go_north()
        when /^(walk east|walk e|go east|east|go e|e)$/
            go_east()
        when /^(walk south|walk s|go south|south|go s|s)$/
            go_south()
        when /^(walk west|walk w|go west|west|go w|w)$/
            go_west()
        end
    end

    private

    def go_north()
        current_location = Location.find_by(current_room: true)
        if current_location.name == "central room"
            new_location = Location.find_by(name: "north room")
            update_current_room(current_location, new_location)
        elsif current_location.name == "south room"
            new_location = Location.find_by(name: "central room")
            update_current_room(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_east()
        current_location = Location.find_by(current_room: true)
        if current_location.name == "central room"
            new_location = Location.find_by(name: "east room")
            update_current_room(current_location, new_location)
        elsif current_location.name == "west room"
            new_location = Location.find_by(name: "central room")
            update_current_room(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_south()
        current_location = Location.find_by(current_room: true)
        if current_location.name == "central room"
            new_location = Location.find_by(name: "south room")
            update_current_room(current_location, new_location)
        elsif current_location.name == "north room"
            new_location = Location.find_by(name: "central room")
            update_current_room(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def go_west()
        current_location = Location.find_by(current_room: true)
        if current_location.name == "central room"
            new_location = Location.find_by(name: "west room")
            update_current_room(current_location, new_location)
        elsif current_location.name == "east room"
            new_location = Location.find_by(name: "central room")
            update_current_room(current_location, new_location)
        else
            return "You can't go that way."
        end
    end

    def update_current_room(current_location, new_location)
        current_location.update(current_room: false)
        new_location.update(current_room: true)
        return "You are in the #{new_location.name}. #{new_location.description}"
    end
end
