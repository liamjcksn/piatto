require 'json'
require 'net/http' # or open-uri but not secure
require 'nokogiri'


class RestaurantsController < ApplicationController
  TAGS = { pasta: %w[pasta spaghetti ravioli tagliolini penne maccheroni spaghettoni spaghetti spaghettini fedelini vermicelloni vermicelli capellini capelli d'angelo barbina bucatini perciatelli fusilli ciriole bavette bavettine fettuce fettuccine fettucelle lagane lasagne lasagnette lasagnotte linguettine linguine mafalde mafaldine pappardelle pillus pizzoccheri sagnarelli scialatelli or scilatielli stringozzi tagliatelle taglierini trenette tripoline calamarata calamaretti cannelloni cavatappi cellentani chifferi ditalini fideuà gomito elicoidali fagioloni fusilli garganelli gemelli maccheroncelli maltagliati manicotti marziani mezzani pasta mezze penne mezzi bombardoni mostaccioli paccheri pasta al ceppo penne rigate penne lisce penne zita rigatoncini rigatoni sagne 'ncannulate spirali spiralini trenne trennette tortiglioni tuffoli gnocchi trofie Campanelle Capunti Casarecce Cavatelli Cencioni Conchiglie Conchiglioni Corzetti Creste di galli Croxetti Farfalle Farfalloni Fiorentine Fiori Foglie d'ulivo Gigli Gramigna Lanterne Lumache Lumaconi Maltagliati Mandala Marille Orecchiette Pipe Quadrefiore Radiatori Ricciolini Ricciutelle Rotelle Rotini Strozzapreti Torchio Trofie Gnocchi Passatelli Spätzle Acini di pepe Bead-like pasta Alfabeto Anelli Anellini Couscous Conchigliette Corallini Ditali Ditalini Egg barley Farfalline Fideos Filini Fregula Funghini Israeli couscous Occhi di pernice Orzo (also, risoni) Pastina Pearl Pasta Ptitim Quadrettini Risi Seme di melone Stelle Stelline Stortini Tarhana Agnolotti Cannelloni Casoncelli or casonsèi Casunziei Fagottini Maultasche Mezzelune Occhi di lupo Pelmeni Pierogi Ravioli Sacchettini Sacchettoni Tortellini Tortelloni],
            pizza: %w[pizza margherita marinara verace diavola capricciosa napoletana ventura calzone cinque formaggi verduretta salsiccia hawaiian pesto],
            indian: %w[indian Alu Gobi Alu Gobi Alu Matar Alu Matar Barfi Barfi Beef Vindaloo Beef Vindaloo Butter Chicken Butter Chicken Carrot Halwa Carrot Halwa Chaat Papri Chaat Papri Cham-Cham Cham-Cham Chana Dal Chana Dal Chana Masala Chana Masala Chapati Chapati Chicken 65 Chicken 65 Chicken Biriyani Chicken Biriyani Chicken Tikka Chicken Tikka Chili Chicken Chili Chicken Coriander Chutney Coriander Chutney Dal Makhani Dal Makhani Date Tamarind Chutney Date Tamarind Chutney Dhokla Dhokla Gulab Jamun Gulab Jamun Idili Idili Jalebi Jalebi Kheema Kheema Kheer Kheer Kulfi Kulfi Ladoo Ladoo Lamb Kebabs Lamb Kebabs Lamb Vindaloo Lamb Vindaloo Lime Pickle Lime Pickle Maili Kofta Veggie Balls Sauce Maili Kofta Mango Lassi Mango Lassi Masala Chai Masala Chai Masala Dosa Masala Dosa Masoor Dal Masoor Dal Medu Vada Medu Vada Naan Navratan Korma  (Nine Gem Curry) Navratan Korma (Nine Gem Curry) Onion Pakora Onion Pakora Papadum Papadum Pulao Pulao],
            chinese: %w[chinese boiled dumplings shuǐ jiǎo sticky buns steamed stuffed bun bao fried noodle plain noodles fried rice noodles steamed white rice vegetarian platter white radish patty spicy tofu beef and rice egg omelet chicken leg and rice Peking duck pork chop and rice fish cooked soy sauce fried rice shrimp crab egg and vegetable soup seaweed soup hot and sour soup],
            japanese: %w[japanese Gohan meshi Genmai gohan Hayashi Kamameshi Katemeshi Sushi maki yakimeshi teriyaki yakitori unagi salmon tuna eel Mochi Mugi gohan Mugi meshi Ochazuke green tea umeboshi tsukemono Okowa Omurice Onigiri Sekihan white rice azuki Takikomi gohan soy dashi Tamago kake gohan egg Tenmusu rice  nori deep-fried tempura shrimp nigiri gunkan temaki],
            italian: %w[italian focaccia breadsticks grissini carpaccio risotto insalata salad],
            american: %w[american burger hot dog fries sandwich milkshake smoothie],
            turkish: %w[turkish kebab] }

  def show
    @restaurant = Restaurant.find(params[:id])
    @dish = @restaurant.dishes.order(average_rating: :desc)
  end

  def create
    # theoretically, anyone could pass in any kind of parameters to create a new restaurant by just making
    # a post request. but, there's no method allowing us to efficiently get a restaurant's info from just
    # its ID, so i think this is the least resource-intensive way to go about things. banking on the fact
    # that rails knows where the post request came from.
    if Restaurant.where(just_eat_id: restaurant_params[:just_eat_id])[0]
      restaurant = Restaurant.find_by(just_eat_id: restaurant_params[:just_eat_id])

      just_eat_id = URI.encode(restaurant_params[:just_eat_id])
      url = "https://uk.api.just-eat.io/restaurants/uk/#{just_eat_id}/catalogue/items?limit=500"
      json_menu = Net::HTTP.get(URI(url))
      new_dishes = []
      JSON.parse(json_menu)["items"].each do |dish|
        if dish["name"] && Dish.find_by(just_eat_dish_id: dish["id"].to_i).nil?
          new_dishes << { just_eat_dish_id: dish["id"].to_i,
                          name: dish["name"],
                          description: dish["description"],
                          restaurant_id: restaurant.id }
        end
      end

      dishes_with_prices = return_objects_with_price(restaurant, new_dishes)
      dishes_with_prices.each { |dish| Dish.create(dish) }

      redirect_to restaurant_path(Restaurant.find_by(just_eat_id: restaurant_params[:just_eat_id]).id)
    else
      restaurant = Restaurant.create(restaurant_params)


       just_eat_id = URI.encode(restaurant_params[:just_eat_id])
       url = "https://uk.api.just-eat.io/restaurants/uk/#{just_eat_id}/catalogue/items?limit=500"
       json_menu = Net::HTTP.get(URI(url))
       new_dishes = []
       JSON.parse(json_menu)["items"].each do |dish|
         new_dishes << { just_eat_dish_id: dish["id"].to_i, name: dish["name"], description: dish["description"], restaurant_id: restaurant.id, average_rating: 0.0, reviews_count: 0 } if dish["name"]
      end

      dishes_with_prices = return_objects_with_price(restaurant, new_dishes)
      dishes_with_prices.each { |dish| Dish.create(dish) }

      redirect_to restaurant_path(restaurant.id)
    end
  end

  private

  def restaurant_params
    params.permit(:name, :just_eat_id, :latitude, :longitude, :url, :logourl, :postcode)
  end

  def return_objects_with_price(restaurant, menu_items)
    menu_item_names = menu_items.map { |menu_item| menu_item[:name] }

    # Scraping:
    restaurant_url = restaurant.url
    url = "#{restaurant_url}/menu"
    html_file = Net::HTTP.get(URI(url))
    html_doc = Nokogiri::HTML(html_file)
    item_class = '.c-menuItems-content'
    search_results = html_doc.search(item_class)
    return false if search_results.empty?

    search_results.each do |element|
      heading = element.search('.c-menuItems-heading')
      price = element.search('.c-menuItems-price')
      if heading.first && price.first && menu_item_names.include?(heading.first.text.strip)
        item = menu_items.select { |menu_item| menu_item[:name] == heading.first.text.strip }.first
        item[:price] = price.first.text.strip.gsub('£', '').to_f * 100
        item[:tags] = make_tag(item)
      end
    end

    return menu_items.reject { |menu_item| menu_item[:price].nil? || menu_item[:price].zero? }.uniq
  end

  def make_tag(dish)
    dish_name = dish[:name]
    p dish_name
    tag_list = []
    tag_frequencies = {}
    TAGS.each do |tag_name, tag_items|
      tag_items.map(&:downcase).uniq.each do |tag_item|
        if /\b#{Regexp.quote(tag_item.downcase)}\b/.match(dish_name.downcase)
          p 'MATCH'
          p tag_item
          tag_list << tag_name
          tag_list << tag_item
        end
      end
    end
    tag_list.each do |t|
      tag_frequencies[t.to_s] = 0 unless tag_frequencies[t.to_s]
      tag_frequencies[t.to_s] += 1
    end
    tag_list ? tag_frequencies.map { |t, f| "#{t}=#{f}" }.join('&') : ""
  end
end
