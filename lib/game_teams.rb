require 'csv'
require_relative './season'

class GameTeams 
  def initialize(game_teams_data, games_data)
    @game_teams_data = game_teams_data
    @games_data = games_data
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

  def average_goals_by_team
    average_goals = Hash.new(0)
    count_of_goals_by_team.each do |team_id, goals|
      average_goals[team_id] = count_of_goals_by_team[team_id] / count_of_games_by_team[team_id].to_f
    end
    average_goals
  end

  def data_by_season(season_id)
    season = Season.new(@games_data, season_id)
    games = season.list_of_game_ids
    @game_teams_data.each_with_object([]) do |row, array|
      array << row if games.include?(row["game_id"])
    end
  end

  

  



end