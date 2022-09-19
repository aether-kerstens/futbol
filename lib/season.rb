require './lib/games'

class Season < Games 
  def initialize(games_data, season)
    super(games_data) 
    @games_data = @games_data.select {|row| row["season"] == season}
  end


end