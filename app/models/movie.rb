class Movie < ActiveRecord::Base
  @@ratings = ['G', 'PG', 'PG-13', 'R']
  def self.all_ratings
    @@ratings
  end
end
