class Movie < ActiveRecord::Base
    attr_accessor :myratings
    def self.myratings
        ['G', 'PG', 'PG-13', 'R']
    end
end
