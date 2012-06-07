class Movie < ActiveRecord::Base
	def Movie.ratings
		['G', 'PG', 'PG-13', 'R']
	end
end
