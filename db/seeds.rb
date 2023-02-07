puts "Clearing db..."
Response.destroy_all

puts "Creating responses"
Response.create(output: "Hello and welcome!")
Response.create(output: "type anything to begin")

puts "Finished seeding!"