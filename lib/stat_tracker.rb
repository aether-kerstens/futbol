require 'csv'
require './lib/games'

class StatTracker
  attr_reader :games_data, :teams_data, :game_teams_data

  def initialize(games_data, teams_data, game_teams_data)
    @games_data = games_data
    @teams_data = teams_data
    @game_teams_data = game_teams_data
    @games = Games.new(games_data)
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

  def highest_total_score
    @games_data.map {|row| row["away_goals"].to_i + row["home_goals"].to_i}.max
  end

  def lowest_total_score
    @games_data.map {|row| (row["away_goals"].to_i + row["home_goals"].to_i)}.min
  end

  def percentage_home_wins
    (@games.total_home_wins / @games.total_games.to_f).round(2)
  end

  def percentage_visitor_wins
    (@games.total_away_wins / @games.total_games.to_f).round(2)
  end

  def percentage_ties
    (@games.total_ties / @games.total_games.to_f).round(2)
  end

  def count_of_games_by_season
    games_by_season = Hash.new(0)
    @games_data.each do |row|
      games_by_season[row["season"]] += 1
    end
    games_by_season
  end

  def average_goals_per_game
    (@games.total_goals / @games.total_games.to_f).round(2)
  end

  def average_goals_by_season
    averages = {}
    @games.get_seasons.each do |season|
      averages[season] = (@games.total_goals_by_season(season) / @games.total_games_by_season(season).to_f).round(2)
    end
    averages
  end
############# END OF GAMES METHODS ################

############# START OF LEAGUE METHODS #############

  # def count_of_teams
  #   @teams_data.map { |row| row["teamName"] }.uniq.count
  #   # teams_total = Hash.new(0)
  #   # @teams_data.map do |row|
  #   #   teams_total[row["teamName"].length]
  # end

  # def best_offense
  # end

  # def worst_offense
  # end 

  def highest_scoring_visitor
    @teams.team_id_to_name.find {|pairs| pairs.find {|key, value| key == @games.high_ave_score_away[0]}}.values[0] 
  end

  def highest_scoring_home_team
    @teams.team_id_to_name.find {|pairs| pairs.find {|key, value| key == @games.high_ave_score_hometeam[0]}}.values[0] 
  end

  def lowest_scoring_visitor
    @teams.team_id_to_name.find {|pairs| pairs.find {|key, value| key == @games.low_ave_score_away[0]}}.values[0]
  end

  def lowest_scoring_home_team
    @teams.team_id_to_name.find {|pairs| pairs.find {|key, value| key == @games.low_ave_score_hometeam[0]}}.values[0] 
  end

  ################ END OF LEAGUE METHODS ##############

  ############### START OF SEASON METHODS ##############

#UNCATEGORIZED HELPER METHOD#
  def data_by_season(season_id)
    games = @games.games_by_season(season_id)
    @game_teams_data.each_with_object([]) do |row, array|
      array << row if games.include?(row["game_id"])
    end
  end

#UNCATEGORIZED HELPER METHOD#
  def wins_by_coach(season_id)
    data_by_season(season_id).each_with_object(Hash.new(0)) do |row, hash|
      row["result"] == "WIN" ? hash[row["head_coach"]] += 1 : hash[row["head_coach"]] += 0
    end
  end

#UNCATEGORIZED HELPER METHOD#
  def sorted_wins_by_coach(season_id)
    wins_by_coach(season_id).sort_by { |coach, wins| wins }.reverse
  end

  def winningest_coach(season_id)
    sorted_wins_by_coach(season_id)[0][0]
  end

  def worst_coach(season_id)
    sorted_wins_by_coach(season_id)[-1][0]
  end
 
  #most accurate team

  #least accurate team

  #most tackles

  #fewest tackles

  ################### END OF SEASON METHODS ##################

  #################### START OF TEAMS METHODS #################

#Start of helper methods for most accurate team and least accurate team
  def team_accuracy_by_season(season_id)
    hash = Hash.new{|h,k| h[k] = {goals: 0, shots: 0}}
    data_by_season(season_id).each do |row|
      hash[row["team_id"]][:goals] += row["goals"].to_i
      hash[row["team_id"]][:shots] += row["shots"].to_i
    end
    hash.each {|team_id, ratio| hash[team_id] = ratio[:goals]/ratio[:shots].to_f}
    hash
  end

  def most_accurate_team(season_id)
    hash = team_accuracy_by_season(season_id)
    get_team_name(hash.key(hash.values.max))
  end

  def least_accurate_team(season_id)
    hash = team_accuracy_by_season(season_id)
    get_team_name(hash.key(hash.values.min))
  end

  def team_info(team_id)
    teams_hash = teams_data.group_by {|row| row}.map {|key, value| Hash[key]}.find {|team| team["team_id"] == team_id}
    teams_hash.delete("Stadium")
    teams_hash["franchise_id"] = teams_hash.delete("franchiseId")
    teams_hash["team_name"] = teams_hash.delete("teamName")
    teams_hash
  end

#UNCATEGORIZED HELPER METHOD#
  def win_totals_by_season(season_id)
    data_by_season(season_id).each_with_object(Hash.new(0)) do |row, hash|
      if row["result"] == "WIN"
        hash[row["team_id"]] += 1
      else
        hash[row["team_id"]] += 0
      end
    end
  end

#UNCATEGORIZED HELPER METHOD#
  def total_games_played_by_season(season_id)
    data_by_season(season_id).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1
    end
  end

#UNCATEGORIZED HELPER METHOD#  
  def team_percentage_wins_by_season(team_id, season_id)
    (win_totals_by_season(season_id)[team_id] / total_games_played_by_season(season_id)[team_id].to_f).round(3)
  end

#UNCATEGORIZED HELPER METHOD#  
  def team_percentage_wins_all_seasons(team_id)
    @games.get_seasons.each_with_object({}) do |season_id, hash|
      hash[season_id] = team_percentage_wins_by_season(team_id, season_id)
    end
  end

  def average_win_percentage(team_id)
    data = @game_teams_data.select{|row| row["team_id"] == team_id}
    total_wins = data.count{|row| row["result"] == "WIN"}
    total_games = count_of_games_by_team[team_id]
    (total_wins / total_games.to_f).round(2)
  end

  def best_season(team_id)
    hash = team_percentage_wins_all_seasons(team_id)
    hash.key(hash.values.max)
  end

  def worst_season(team_id)
    hash = team_percentage_wins_all_seasons(team_id)
    hash.key(hash.values.min)
  end

  # average win percentage 

  def count_of_teams
    @teams_data.map { |row| row["teamName"] }.uniq.count
  end

  def count_of_games_by_team
    games_by_team = Hash.new(0)
    @game_teams_data.each do |row|
      games_by_team[row["team_id"]] += 1
    end
    games_by_team
  end

  def count_of_goals_by_team
    goals_by_team = Hash.new(0)
    @game_teams_data.each do |row|
      goals_by_team[row["team_id"]] += row["goals"].to_i
    end
    goals_by_team
  end

  def get_teams
    @teams_data.map {|row| row["team_id"]}.uniq
  end

  def average_goals_by_team
    average_goals = Hash.new(0)
    count_of_goals_by_team.each do |team_id, goals|
      average_goals[team_id] = count_of_goals_by_team[team_id] / count_of_games_by_team[team_id].to_f
    end
    average_goals
  end

  def best_offense
    team_id = average_goals_by_team.key(average_goals_by_team.values.max)
    get_team_name(team_id)
  end

  def worst_offense
    team_id = average_goals_by_team.key(average_goals_by_team.values.min)
    get_team_name(team_id)
  end

  def most_goals_scored(team_id)
    goals_scored = @games.away_goals_high + @games.home_goals_high
    goals_scored.map {|team_scores| team_scores[team_id]}.compact.max
  end

  def fewest_goals_scored(team_id)
    goals_scored_few = @games.away_goals_low + @games.home_goals_low
    goals_scored_few.map {|team_scores| team_scores[team_id]}.compact.min
  end

#UNCATEGORIZED HELPER METHOD#
  def game_ids_by_team(team_id)
    @games_data.each_with_object([]) do |row, array|
      array << row["game_id"] if row["away_team_id"] == team_id || row["home_team_id"] == team_id
    end
  end

#UNCATEGORIZED HELPER METHOD# 
  def opponents_data(team_id)
    games = game_ids_by_team(team_id)
    @game_teams_data.each_with_object([]) do |row, array|
      array << row if games.include?(row["game_id"]) && row["team_id"] != team_id 
    end
  end

#UNCATEGORIZED HELPER METHOD#  
  def opponents_win_totals(team_id)
    opponents_data(team_id).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1 if row["result"] == "WIN"
    end
  end

#UNCATEGORIZED HELPER METHOD#  
  def opponents_games_totals(team_id)
    opponents_data(team_id).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1
    end
  end

#UNCATEGORIZED HELPER METHOD#  
  def opponent_win_percentage(team_id, opponent_id)
    (opponents_win_totals(team_id)[opponent_id] / opponents_games_totals(team_id)[opponent_id].to_f).round(3)
  end

#UNCATEGORIZED HELPER METHOD#  
  def opponents_ids(team_id)
    opponents_data(team_id).map { |row| row["team_id"] }.uniq
  end

#UNCATEGORIZED HELPER METHOD#  
  def all_opponents_win_percentages(team_id)
    opponents_ids(team_id).each_with_object(Hash.new(0)) do |opponent_id, hash|
      hash[opponent_id] = opponent_win_percentage(team_id, opponent_id)
    end
  end

#UNCATEGORIZED HELPER METHOD#
  def get_team_name(team_id)
    team = @teams_data.find { |row| row["team_id"] == team_id }
    team["teamName"]
  end

  def favorite_opponent(team_id)
    hash = all_opponents_win_percentages(team_id)
    get_team_name(hash.key(hash.values.min))
  end

  def rival(team_id)
    hash = all_opponents_win_percentages(team_id)
    get_team_name(hash.key(hash.values.max))
  end
end
