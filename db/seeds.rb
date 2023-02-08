puts "Clearing db..."
Gamestate.destroy_all
Location.destroy_all
Item.destroy_all

puts "Creating Locations"
Location.create(name: "inventory", description: "the inside of your bag", current_room: false)
Location.create(name: "central room", description: "A cozy room with a fireplace. There are doors to the north, east, south, and west.", current_room: true)
Location.create(name: "north room", description: "A large library. There is a door to the south.", current_room: false)
Location.create(name: "east room", description: "A vast wine cellar. There is a door to the west.", current_room: false)
Location.create(name: "south room", description: "A luxurious bathroom with a clawfoot tub. There is a door to the north.", current_room: false)
Location.create(name: "west room", description: "A fancy bedroom. There is a door to the east.", current_room: false)

puts "Creating Items"
Item.create(name: "key", description: "A shiny brass key.", location_id: 2, in_inventory: false)
Item.create(name: "book", description: "A leather bound book.", location_id: 1, in_inventory: true)
Item.create(name: "towel", description: "It's always good to have a towel around.", location_id: 1, in_inventory: true)

puts "Creating Gamestates"
Gamestate.create(output: "Welcome!", room: "central room")
Gamestate.create(output: "If you need help, try typing \"help\".", room: "central room")
Gamestate.create(output: "You are standing in a cozy room with a fireplace. There are doors to the north, east, south, and west.", room: "central room")

puts "Finished seeding!"
