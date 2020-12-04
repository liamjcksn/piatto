# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
    # require 'open-uri'

    # number_of_users = 50

    # puts 'creating fake users...'
    # number_of_users.times do |n|
    #   username = Faker::Internet.username
    #   username = "#{username}_#{n}"
    #   user = User.new(
    #     first_name: "#{Faker::Name.first_name}",
    #     last_name: "#{Faker::Name.last_name}",
    #     username: username,
    #     email: "#{Faker::Internet.email}",
    #     password: 'piattopassword12345'
    #   )
    #   user.save!
    # end

    # puts 'creating followings...'
    # first_set = number_of_users.times.map { rand(1..number_of_users) }
    # second_set = number_of_users.times.map { rand(1..number_of_users) }
    # number_of_users.times do |n|
    #   Following.create(follower: User.find(first_set[n - 1]), followee: User.find(second_set[n - 1]))
    # end

    # puts 'creating fake restaurants...'
    # 10.times do
    #   restaurant = Restaurant.new(
    #     name: "#{Faker::Restaurant.name}",
    #     latitude: "#{Faker::Address.latitude}",
    #     longitude: "#{Faker::Address.longitude}",
    #     postcode: "#{Faker::Address.postcode}"
    #     # description: "#{Faker::Restaurant.description}"
    #   )
    #   restaurant.save!
    # end

    # puts 'creating fake dishes...'
    # 15.times do
    #   dish = Dish.new(
    #     name: "#{Faker::Food.dish}",
    #     description: "#{Faker::Lorem.sentences(number: rand(3..5)).join("")}",
    #     restaurant_id: rand(1..10),
    #     price: rand(100..2000),
    #     average_rating: 0,
    #     reviews_count: 0,
    #     tags: "pizza=1&margherita=1"
    #   )
    #   dish.save!
    # end
    good_reviews = ["That was delicious", "Yummy!", "I loved te presentation", "It came kind of wet but it tasted great", "I loved it", "Tasted a bit funny but in a nice way", "Yum", "I love this", "I ordered another one!", "I don't know why but this tastes like chicken and I love it", "I'm gonna have this on my piatto on the daily", "I don't like it. I LOVE IT!", "This tasted bad. But like, the slang kind of bad. So good!", "Tasted like my friend Charles' delicious cooking", "Has some weird australian vibes", "Reminds me of my childhood", "I love this. IT'S SO GOOD!", "That was nice", "I feel so happy after ordering this", "Makes me smile inside", "I have a thing for this dish. Is that strange? Does that make me strange?", "MMMMMMM", "Tastes like a great dish", "Had lots of seeds! I love seeds! Let's seed every dish.", "Piatto is the best platform. I love it. And this dish ain't that bad either.", "Hey! I loved this!", "Wow! Had me back for seconds.", "The delivery driver even tried to have some himself, it was so good.", "YUM YUM YUM", "Who wouldn't order this?", "Tastes like love and happiness", "I love this dish. Seriously. It's AMAZING!", "I have this in all my dishlists.", "Wow. Just wow. I thought it would be unhealthy or something but it tastes so good. And it's slightly different to how it is in other places.", "I love this", "Why did I never order this before?", "My jaw hurts now, because it's SO GOOD I ORDERED SECONDS!", "WOW! AMAZING!"]
    bad_reviews = ["Awful", "It was cold", "It was too hot. Burned my tongue!", "It was pretty bland actually", "Not the biggest of fans TBH", "It was too small", "It was way too big", "Bad value for money", "Costs too much for what it is", "It smells kinda funny", "Found a hair", "It tasted a bit like soap", "My sister and her fiancee got this last week. There was a battery in my order! A whole double A battery!", "Tasted like chicken. Should not taste like chicken", "Reminds me of my father. I have father issues. How dare you.", "Reminds me of New York City. I licked a subway platform once.", "This is gross. DO NOT ORDER", "WHY WOULD ANYONE FALL FOR THIS", "Came undercooked", "Came too quickly", "Took way too long to come.", "They said it was a good dish. They lied.", "Ha! Are you seriously considering this dish? You idiot!", "I think you should reconsider your life if you're considering this dish.", "Listen. I don't order much. But this made me remember why.", "I am allergic to this dish. Not in a biological sense, it's just so bad.", "Reminds me of my friend Lloyd", "I can't believe I actually ordered this. I mean, it looked ok, but I should have known.", "I CHUNDERED EVERYWHERE", "Not a fan", "Dish was meh", "It was like pottery class in year 4.", "I cannot eat this", "Why did I order this?", "I hate this.", "WHY WOULD ANYONE ORDER THIS!?", "YUMMY YUMMY but in a bad way", "meh."]



    Dish.all.sample(Dish.count * 2 / 3).each do |dish|
      p dish
      rand(1..20).times do
        if rand(1..2) == 1
          p '1'
          Review.create!(rating: rand(1..2), content: bad_reviews.sample, user_id: rand(4..User.count), dish_id: dish.id)
        else
          p '2'
          Review.create!(rating: rand(3..5), content: good_reviews.sample, user_id: rand(4..User.count), dish_id: dish.id)
        end
      end
    end



