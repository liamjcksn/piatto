class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :dishlists
  has_many :reviews

  has_many :followings
  has_many :following_users, class_name: 'Following', foreign_key: 'followee_id' # , primary_key: 'id'
  has_many :followers, through: :following_users
  has_many :followed_users, class_name: 'Following', foreign_key: 'follower_id' # , primary_key: 'id'
  has_many :followees, through: :followed_users

  # def followers
  #   self.follower_objects.all.map { |f| User.find(f.follower_id) }
  # end

  # [...]
  include PgSearch::Model
  pg_search_scope :search_by_username_or_name,
                  against: [:username, :first_name, :last_name],
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }
end
