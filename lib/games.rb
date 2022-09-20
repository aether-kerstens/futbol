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

  def total_goals
    @games_data.map {|row| row["away_goals"].to_i + row["home_goals"].to_i}.sum
  end

  def get_seasons
    @games_data.map {|row| row["season"]}.uniq
  end

  def ave_score_away
    @games_data.group_by {|row| row["away_team_id"]}.map do |tid, scores|
      {tid => scores.sum {|score| score["away_goals"].to_i}.to_f/ scores.length}
    end
  end

  def ave_score_home
    @games_data.group_by {|row| row["home_team_id"]}.map do |tid, scores|
      {tid => scores.sum {|score| score["home_goals"].to_i}.to_f/ scores.length}
    end
  end

  def low_ave_score_away
    ave_score_away.min_by{|hash| hash.values}.keys
  end

  def high_ave_score_away
    ave_score_away.max_by{|hash| hash.values}.keys
  end

  def low_ave_score_hometeam
    ave_score_home.min_by{|hash| hash.values}.keys
  end

  def high_ave_score_hometeam
    ave_score_home.max_by{|hash| hash.values}.keys
  end

  def away_goals_high
    @games_data.group_by {|row| row["away_team_id"]}.map do |tid, scores|
      {tid => scores.map {|score| score["away_goals"].to_i}.max}
    end
  end

  def home_goals_high
      @games_data.group_by {|row| row["home_team_id"]}.map do |tid, scores|
        {tid => scores.map {|score| score["home_goals"].to_i}.max}
      end
  end

  def away_goals_low
    @games_data.group_by {|row| row["away_team_id"]}.map do |tid, scores|
      {tid => scores.map {|score| score["away_goals"].to_i}.min}
    end
  end

  def home_goals_low
    @games_data.group_by {|row| row["home_team_id"]}.map do |tid, scores|
      {tid => scores.map {|score| score["home_goals"].to_i}.min}
    end
  end

  def total_goals_by_season(season)
    @games_data.reject {|row| row["season"] != season}.map {|row| row["away_goals"].to_i + row["home_goals"].to_i}.sum
  end

  def total_games_by_season(season)
    @games_data.count {|row| row["season"] == season}
  end

  def list_of_game_ids
    @games_data.map {|row| row["game_id"]}
  end

  def game_ids_by_team(team_id)
    @games_data.each_with_object([]) do |row, array|
      array << row["game_id"] if row["away_team_id"] == team_id || row["home_team_id"] == team_id
    end
  end

  def count_of_games_by_season
    @games_data.each_with_object(Hash.new(0)) do |row, hash|
      hash[row["season"]] += 1
    end
  end

  def highest_total_score
    @games_data.map {|row| row["away_goals"].to_i + row["home_goals"].to_i}.max
  end

  def lowest_total_score
    @games_data.map {|row| (row["away_goals"].to_i + row["home_goals"].to_i)}.min
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
