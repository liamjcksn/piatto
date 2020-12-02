class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :dishlist_dishes
  has_many :dishlists, through: :dishlist_dishes
  has_many :reviews

  include PgSearch::Model
  pg_search_scope :search_by_dish,
                  against: [:name, :description],
                  # associated_against: {
                  #   restaurant: [:name]
                  # },
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }
  pg_search_scope :search_by_tag,
                  against: [:tags],
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }


  def get_similar_dishes(n, cookies)
    tags = self.tags.split("&").map { |arr| arr.split("=") }.to_h.sort_by { |_, f| f } # or :tags
    similar_dishes = []
    tags.each do |arr|
      Dish.search_by_tag(arr[0]).select { |dish| local_restaurants_array(cookies).include?(dish.restaurant.just_eat_id) }.first(arr[1].to_i).each { |dish| similar_dishes << dish }
      break if similar_dishes.size >= n
    end
    return similar_dishes
  end

  private

  def local_restaurants_array(cookies)
    local_string = ""
    only_ids = cookies.select do |cookie, _|
      cookie.start_with?("local_restaurants_")
    end
    only_ids.each { |_, value| local_string += "#{value}&" }
    local_string.split('&').map(&:to_i)
  end
end
