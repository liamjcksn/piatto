# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
    require 'open-uri'


    number_of_users = 50

    puts 'creating fake users...'
    number_of_users.times do |n|
      username = Faker::Internet.user_name
      username = "#{username}_#{n}"
      user = User.new(
        first_name: "#{Faker::GreekPhilosophers.name}",
        last_name: "#{Faker::Space.planet }",
        username: username,
        email: "#{Faker::Internet.email}",
        password: 'piattopassword12345'
      )
      user.save!
    end

    puts 'creating followings...'
    first_set = number_of_users.times.map { rand(1..number_of_users) }
    second_set = number_of_users.times.map { rand(1..number_of_users) }
    number_of_users.times do |n|
      Following.create(follower: User.find(first_set[n - 1]), followee: User.find(second_set[n - 1]))
    end

    puts 'creating fake restaurants...'
    10.times do
      restaurant = Restaurant.new(
        name: "#{Faker::Restaurant.name}",
        latitude: "#{Faker::Address.latitude}",
        longitude: "#{Faker::Address.longitude}",
        postcode: "#{Faker::Address.postcode}"
        # description: "#{Faker::Restaurant.description}"
      )
      restaurant.save!
    end

    puts 'creating fake dishes...'
    15.times do
      dish = Dish.new(
        name: "#{Faker::Food.dish}",
        description: "#{Faker::Food.description}",
        restaurant_id: rand(1..10),
        price: rand(1..20)
      )
      dish.save!
    end



