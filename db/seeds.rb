puts "Clearing db..."
Gamestate.destroy_all
Location.destroy_all
Item.destroy_all

puts "Creating Locations"
Location.create(name: "central room", description: "A cozy room with a fireplace.", current_room: true)
Location.create(name: "north room", description: "A large library.", current_room: false)
Location.create(name: "east room", description: "A vast wine cellar.", current_room: false)
Location.create(name: "south room", description: "A luxurious bathroom with a clawfoot tub.", current_room: false)
Location.create(name: "west room", description: "A bedroom.", current_room: false)

puts "Creating Items"
Item.create(name: "key", description: "A shiny brass key.", location_id: 1, in_inventory: false)
Item.create(name: "book", description: "A leather bound book.", in_inventory: true)
Item.create(name: "towel", description: "It's always good to have a towel around.", location_id: 4, in_inventory: false)

puts "Creating Gamestates"
Gamestate.create(output: "Hello and welcome!", room: "central room")
Gamestate.create(output: "You are in a room. There are doors to the north, east, south, and west.", room: "central room")
Gamestate.create(output: "If you need help, try [help]", room: "central room")

puts "Finished seeding!"