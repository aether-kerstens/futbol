require 'csv'

class Games 
  def initialize(games_data)
    @games_data = games_data 
  end

  def total_home_wins
    @games_data.count { |row| row["home_goals"].to_i > row["away_goals"].to_i }
  end

  def total_games
    @games_data.count
  end

  def total_away_wins
    @games_data.count { |row| row["away_goals"].to_i > row["home_goals"].to_i }
  end

  def total_ties
    @games_data.count { |row| row["away_goals"].to_i == row["home_goals"].to_i }
  end
end















# @total_score_away = Hash.new(0)
# @total_score_home = Hash.new(0)
# @total_away_games = Hash.new(0)
# @total_home_games = Hash.new(0)  
#     @away_scores = Hash.new{|key, hash| hash[key] = []}
#     @home_scores = Hash.new{|key, hash| hash[key] = []}

#     games_data.each do |row|
#       # @total_score_away[row["away_team_id"]] += row["away_goals"].to_i 
#       # @total_score_home[row["home_team_id"]] += row["home_goals"].to_i 
#       # @total_home_games[row["home_team_id"]] += 1
#       # @total_away_games[row["away_team_id"]] += 1 
#       @away_scores[row["away_team_id"]] << row["away_goals"]
#       @home_scores[row["home_team_id"]] << row["home_goals"]
#     end
#   end
#   # {away_id: [1, 3, 6], ...}
#   # {home_id: [3, 4, 5], ....}

#   def ave_score_away
#     @total_score_away / @total_away_games

#   end

 
# end