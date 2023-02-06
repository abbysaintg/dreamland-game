puts "Clearing db..."
Output.destroy_all

puts "Creating outputs"
Output.create(text: "Welcome!")
Output.create(text: "Type anything to get started")

puts "Finished seeding!"