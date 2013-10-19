class Movie < ActiveRecord::Base
  def self.get_all_ratings
    movies = Movie.all
    all_ratings = Array.new
    movies.each do |x|
      all_ratings << x.rating
    end
    all_ratings.uniq
  end
end
