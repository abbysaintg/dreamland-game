puts "Clearing db..."
Gamestate.destroy_all
Location.destroy_all
Item.destroy_all

puts "Creating Locations"
Location.create(current_location: false, visited: false, name: "inventory", desc: "the inside of your bag")
Location.create(current_location: true, visited: true, name: "central room", desc: "A cozy room with a fireplace.", exits: "There are rooms to the north, east, south, and a locked door to the west.")
Location.create(current_location: false, visited: false, name: "north room", desc: "A large library.", exits: "There is a door to the south.")
Location.create(current_location: false, visited: false, name: "east room", desc: "A vast wine cellar.", exits: "There is a door to the west.")
Location.create(current_location: false, visited: false, name: "south room", desc: "A luxurious bathroom with a clawfoot tub.", exits: "There is a door to the north.")
Location.create(current_location: false, visited: false, name: "west room", desc: "A fancy bedroom.", exits: "There is a locked door to the east.")

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
Gamestate.create(location_id: 2, output: "You have no idea where you are. Why don't you take a \"look\"?")

puts "Finished seeding!"
