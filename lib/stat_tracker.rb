require 'csv'
require_relative './games'
require_relative './teams'
require_relative './game_teams'
require_relative './season'

class StatTracker
  attr_reader :games_data, :teams_data, :game_teams_data

  def initialize(games_data, teams_data, game_teams_data)
    @games_data = games_data
    @teams_data = teams_data
    @game_teams_data = game_teams_data
    @games = Games.new(games_data)
    @teams = Teams.new(teams_data)
    @game_teams = GameTeams.new(game_teams_data, games_data)
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
    @games_data.each_with_object(Hash.new(0)) do |row, hash|
      hash[row["season"]] += 1
    end
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
  def best_offense
    team_id = @game_teams.average_goals_by_team.key(@game_teams.average_goals_by_team.values.max)
    @teams.get_team_name(team_id)
  end

  def worst_offense
    team_id = @game_teams.average_goals_by_team.key(@game_teams.average_goals_by_team.values.min)
    @teams.get_team_name(team_id)
  end

  def count_of_teams
    @teams.count_of_teams
  end

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
  def winningest_coach(season)
    hash = @game_teams.wins_by_coach(season)
    hash.key(hash.values.max)
  end

  def worst_coach(season)
    hash = @game_teams.wins_by_coach(season)
    hash.key(hash.values.min)
  end

  def most_accurate_team(season)
    hash = @game_teams.team_accuracy_by_season(season)
    @teams.get_team_name(hash.key(hash.values.max))
  end

  def least_accurate_team(season)
    hash = @game_teams.team_accuracy_by_season(season)
    @teams.get_team_name(hash.key(hash.values.min))
  end

  def most_tackles(season)
    id = @game_teams.tackles_by_team(season).key(@game_teams.tackles_by_team(season).values.max)
    @teams.get_team_name(id)
  end

  def fewest_tackles(season)
    id = @game_teams.tackles_by_team(season).key(@game_teams.tackles_by_team(season).values.min)
    @teams.get_team_name(id)
  end
  ################### END OF SEASON METHODS ##################
  #################### START OF TEAMS METHODS #################
  def team_info(team_id)
    @teams.team_info(team_id)
  end

  def average_win_percentage(team_id)
    (@game_teams.team_total_wins(team_id) / @game_teams.count_of_games_by_team[team_id].to_f).round(2)
  end

  def best_season(team_id)
    hash = @game_teams.team_percentage_wins_all_seasons(team_id)
    hash.key(hash.values.max)
  end

  def worst_season(team_id)
    hash = @game_teams.team_percentage_wins_all_seasons(team_id)
    hash.key(hash.values.min)
  end

  def most_goals_scored(team_id)
    goals_scored = @games.away_goals_high + @games.home_goals_high
    goals_scored.map {|team_scores| team_scores[team_id]}.compact.max
  end

  def fewest_goals_scored(team_id)
    goals_scored_few = @games.away_goals_low + @games.home_goals_low
    goals_scored_few.map {|team_scores| team_scores[team_id]}.compact.min
  end
#helper methods that multiple classes are using: modules
#create a class method on game (all) game.all would return an array on
#make game objects

  def favorite_opponent(team_id)
    hash = @game_teams.all_opponents_win_percentages(team_id)
    @teams.get_team_name(hash.key(hash.values.min))
  end

  def rival(team_id)
    hash = @game_teams.all_opponents_win_percentages(team_id)
    @teams.get_team_name(hash.key(hash.values.max))
  end
end
