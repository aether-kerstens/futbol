require 'csv'
require_relative './season'
require_relative './games'
require_relative './min_and_maxable'

class GameTeams
  include MinAndMaxable
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

  def data_by_season(season)
    season = Season.new(@games_data, season)
    games = season.list_of_game_ids
    @game_teams_data.each_with_object([]) do |row, array|
      array << row if games.include?(row["game_id"])
    end
  end

  def wins_by_coach(season)
    data_by_season(season).each_with_object(Hash.new(0)) do |row, hash|
      row["result"] == "WIN" ? hash[row["head_coach"]] += 1 : hash[row["head_coach"]] += 0
    end
  end

  def tackles_by_team(season)
    data_by_season(season).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += row["tackles"].to_i
    end
  end

  def team_accuracy_by_season(season)
    hash = Hash.new{|h,k| h[k] = {goals: 0, shots: 0}}
    data_by_season(season).each do |row|
      hash[row["team_id"]][:goals] += row["goals"].to_i
      hash[row["team_id"]][:shots] += row["shots"].to_i
    end
    hash.each {|team_id, ratio| hash[team_id] = ratio[:goals]/ratio[:shots].to_f}
    hash
  end

  def win_totals_by_season(season)
    data_by_season(season).each_with_object(Hash.new(0)) do |row, hash|
      if row["result"] == "WIN"
        hash[row["team_id"]] += 1
      else
        hash[row["team_id"]] += 0
      end
    end
  end

  def total_games_played_by_season(season)
    data_by_season(season).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1
    end
  end

  def team_percentage_wins_by_season(team_id, season)
    (win_totals_by_season(season)[team_id] / total_games_played_by_season(season)[team_id].to_f).round(3)
  end

   def team_percentage_wins_all_seasons(team_id)
    games = Games.new(@games_data)
    games.get_seasons.each_with_object({}) do |season_id, hash|
      hash[season_id] = team_percentage_wins_by_season(team_id, season_id)
    end
  end

  def opponents_data(team_id)
    games = Games.new(@games_data).game_ids_by_team(team_id)
    @game_teams_data.select do |row|
      games.include?(row["game_id"]) && row["team_id"] != team_id
    end
  end

  def opponents_win_totals(team_id)
    opponents_data(team_id).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1 if row["result"] == "WIN"
    end
  end

  def opponents_games_totals(team_id)
    opponents_data(team_id).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1
    end
  end

  def opponent_win_percentage(team_id, opponent_id)
    (opponents_win_totals(team_id)[opponent_id] / opponents_games_totals(team_id)[opponent_id].to_f).round(3)
  end

  def opponents_ids(team_id)
    opponents_data(team_id).map { |row| row["team_id"] }.uniq
  end

  def all_opponents_win_percentages(team_id)
    opponents_ids(team_id).each_with_object(Hash.new(0)) do |opponent_id, hash|
      hash[opponent_id] = opponent_win_percentage(team_id, opponent_id)
    end
  end

  def data_by_team(team_id)
    @game_teams_data.select{|row| row["team_id"] == team_id}
  end

  def team_total_wins(team_id)
    data_by_team(team_id).count{|row| row["result"] == "WIN"}
  end

  def max_opponents_win(team_id)
    key_at_max(all_opponents_win_percentages(team_id))
  end

  def min_opponents_win(team_id)
    key_at_min(all_opponents_win_percentages(team_id))
  end
end
