require 'csv'

class StatTracker
  attr_reader :games_data, :teams_data, :game_teams_data

  def initialize(games_data, teams_data, game_teams_data)
    @games_data = games_data
    @teams_data = teams_data
    @game_teams_data = game_teams_data
  end

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]
    games_data = CSV.read game_path, headers:true
    teams_data = CSV.read team_path, headers:true
    game_teams_data = CSV.read game_teams_path, headers:true
    StatTracker.new(games_data, teams_data, game_teams_data)
  end

  # def test
  #   @games_data.map do|row|
  #     row["game_id"]
  #   end
  # end


  def low_ave_score_away
    @games_data.group_by {|row| row["away_team_id"]}.map do |tid, scores|
      {tid => scores.sum {|score| score["away_goals"].to_i}.to_f/ scores.length} 
    end 
  end

  def low_ave_score_team
    low_ave_score_away.min_by{|hash| hash.values}.keys
  end

  def team_id_to_name
    @teams_data.map do |row|
      {row["team_id"] => row["teamName"]}
    end
  end

  def lowest_scoring_visitor
    team_id_to_name.find {|pairs| pairs.find {|key, value| p value if key == low_ave_score_team[0]}}.values[0] 
  end

  #iterate over hash and go into each 'average' hash and find the lowest value. then look at teams for the name
  #when refactoring- look into memoization, can use fixture files on own test 




  def highest_total_score
    @games_data.map {|row| row["away_goals"].to_i + row["home_goals"].to_i}.max
  end

  def lowest_total_score
    @games_data.map {|row| (row["away_goals"].to_i + row["home_goals"].to_i)}.min
  end

  def get_seasons
    @games_data.map {|row| row["season"].to_i}.uniq
  end

  def total_home_wins
    @games_data.count { |row| row["home_goals"].to_i > row["away_goals"].to_i }
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

  def total_games
    @games_data.count
  end

  def total_goals_by_season(season)
    @games_data.reject {|row| row["season"].to_i != season}.map {|row| row["away_goals"].to_i + row["home_goals"].to_i}.sum
  end

  def total_games_by_season(season)
    @games_data.count {|row| row["season"].to_i == season}
  end

  def percentage_home_wins
    (total_home_wins / total_games.to_f).round(2)
  end

  def percentage_visitor_wins
    (total_away_wins / total_games.to_f).round(2)
  end

  def percentage_ties
    (total_ties / total_games.to_f).round(2)
  end

  def average_goals_per_game
    (total_goals / total_games.to_f).round(2)
  end

  def average_goals_by_season
    averages = {}
    get_seasons.each do |season|
      averages[season] = (total_goals_by_season(season) / total_games_by_season(season).to_f).round(2)
    end
    averages
  end

  def games_by_season(season_id)
    @games_data.each_with_object([]) do |row, array|
      array << row["game_id"] if row["season"] == season_id
    end
  end

  def data_by_season(season_id)
    games = games_by_season(season_id)
    @game_teams_data.each_with_object([]) do |row, array| 
      array << row if games.include?(row["game_id"])
    end
  end

  def wins_by_coach(season_id) 
    data_by_season(season_id).each_with_object(Hash.new(0)) do |row, hash|
      row["result"] == "WIN" ? hash[row["head_coach"]] += 1 : hash[row["head_coach"]] += 0
    end
  end

  def sorted_wins_by_coach(season_id)
    wins_by_coach(season_id).sort_by { |coach, wins| wins }.reverse
  end

  def winningest_coach(season_id)
    sorted_wins_by_coach(season_id)[0][0]
  end

  def worst_coach(season_id)
    sorted_wins_by_coach(season_id)[-1][0]
  end
end
