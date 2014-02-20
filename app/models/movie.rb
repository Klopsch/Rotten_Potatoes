class Movie < ActiveRecord::Base
  # List of movie ratings
  def self.ratings_set
    ['G', 'PG', 'PG-13', 'R']
  end
end
