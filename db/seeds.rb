puts "Clearing db..."
Gamestate.destroy_all
Location.destroy_all
Item.destroy_all

puts "Creating Locations"
Location.create(current_location: false, visited: false, name: "inventory", desc: "the inside of your bag")
Location.create(current_location: true, visited: true, name: "central room", desc: "A cozy room with a fireplace. There are doors to the north, east, south, and west.")
Location.create(current_location: false, visited: false, name: "north room", desc: "A large library. There is a door to the south.")
Location.create(current_location: false, visited: false, name: "east room", desc: "A vast wine cellar. There is a door to the west.")
Location.create(current_location: false, visited: false, name: "south room", desc: "A luxurious bathroom with a clawfoot tub. There is a door to the north.")
Location.create(current_location: false, visited: false, name: "west room", desc: "A fancy bedroom. There is a door to the east.")

puts "Creating Items"
Item.create(location_id: 1, name: "towel", desc: "never leave home without a towel")
Item.create(location_id: 2, name: "key", desc: "A shiny brass key.")
Item.create(location_id: 3, name: "book", desc: "A leather bound book.")
Item.create(location_id: 4, name: "hat", desc: "A nice hat.")
Item.create(location_id: 5, name: "water bottle", desc: "Stay hydrated!")
Item.create(location_id: 6, name: "cake", desc: "Perfectly frosted. One piece is missing.")


puts "Creating Gamestates"
Gamestate.create(location_id: 2, output: "Welcome!")
Gamestate.create(location_id: 2, output: "If you need help, try typing \"help\".")
Gamestate.create(location_id: 2, output: "You are standing in a cozy room with a fireplace. There are doors to the north, east, south, and west. You see a key here.")

puts "Finished seeding!"
