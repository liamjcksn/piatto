# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

    puts 'creating fake users...'
    5.times do
      user = User.new(
        first_name: "#{Faker::GreekPhilosophers.name}",
        last_name: "#{Faker::Space.planet }",
        username: "#{Faker::Name.unique.clear}",
        email: "#{Faker::Internet.email}",
        password: 'piattopassword12345'
      )
      user.save!
    end

    puts 'creating fake restaurants...'
    10.times do
      restaurant = Restaurant.new(
        name: "#{Faker::Restaurant.name}",
        # description: "#{Faker::Restaurant.description}"
      )
      restaurant.save!
    end
    
    puts 'creating fake dishes...'
    15.times do
      dish = Dish.new(
        name: "#{Faker::Food.dish}",
        description: "#{Faker::Food.description}",
        restaurant_id: rand(1..10)
      )
      dish.save!
    end


  
