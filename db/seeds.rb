puts "Clearing db..."
Gamestate.destroy_all
Location.destroy_all
Item.destroy_all

puts "Creating Locations"
Location.create(name: "central room", description: "A cozy room with a fireplace. There are doors to the north, east, south, and west.", current_room: true)
Location.create(name: "north room", description: "A large library. There is a door to the south.", current_room: false)
Location.create(name: "east room", description: "A vast wine cellar. There is a door to the west.", current_room: false)
Location.create(name: "south room", description: "A luxurious bathroom with a clawfoot tub. There is a door to the north.", current_room: false)
Location.create(name: "west room", description: "A fancy bedroom. There is a door to the east.", current_room: false)

puts "Creating Items"
Item.create(name: "key", description: "A shiny brass key.", location_id: 1, in_inventory: false)
Item.create(name: "book", description: "A leather bound book.", in_inventory: true)
Item.create(name: "towel", description: "It's always good to have a towel around.", location_id: 4, in_inventory: false)

puts "Creating Gamestates"
# Gamestate.create(
#     output:"
# _______  .______       _______     ___      .___  ___.  __          ___      .__   __.  _______  
# |       \ |   _  \     |   ____|   /   \     |   \/   | |  |        /   \     |  \ |  | |       \ 
# |  .--.  ||  |_)  |    |  |__     /  ^  \    |  \  /  | |  |       /  ^  \    |   \|  | |  .--.  |
# |  |  |  ||      /     |   __|   /  /_\  \   |  |\/|  | |  |      /  /_\  \   |  . `  | |  |  |  |
# |  '--'  ||  |\  \----.|  |____ /  _____  \  |  |  |  | |  `----./  _____  \  |  |\   | |  '--'  |
# |_______/ | _| `._____||_______/__/     \__\ |__|  |__| |_______/__/     \__\ |__| \__| |_______/ 
#                                                                                                       ",
#     room: "central room",
# )
Gamestate.create(output: "If you need help, try typing \"help\".", room: "central room")
Gamestate.create(output: "You are standing in a cozy room with a fireplace. There are doors to the north, east, south, and west.", room: "central room")

puts "Finished seeding!"
