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
    team_id_to_name.find {|pairs| pairs.find {|key, value| key == low_ave_score_team[0]}}.values[0]
  end

  def highest_scoring_visitor
    team_id_to_name.find {|pairs| pairs.find {|key, value| key == high_ave_score_team[0]}}.values[0]
  end

  def high_ave_score_team
    low_ave_score_away.max_by{|hash| hash.values}.keys
  end

  def high_ave_score_away
    @games_data.group_by {|row| row["away_team_id"]}.map do |tid, scores|
      {tid => scores.sum {|score| score["away_goals"].to_i}.to_f/ scores.length}
    end
  end

  def low_ave_score_home
    @games_data.group_by {|row| row["home_team_id"]}.map do |tid, scores|
      {tid => scores.sum {|score| score["home_goals"].to_i}.to_f/ scores.length}
    end
  end

  def low_ave_score_hometeam
    low_ave_score_home.min_by{|hash| hash.values}.keys
  end

  def lowest_scoring_home_team
    team_id_to_name.find {|pairs| pairs.find {|key, value| key == low_ave_score_hometeam[0]}}.values[0]
  end

  def highest_scoring_home_team
    team_id_to_name.find {|pairs| pairs.find {|key, value| key == high_ave_score_hometeam[0]}}.values[0]
  end

  def high_ave_score_hometeam
    high_ave_score_home.max_by{|hash| hash.values}.keys
  end

  def high_ave_score_home
    @games_data.group_by {|row| row["home_team_id"]}.map do |tid, scores|
      {tid => scores.sum {|score| score["home_goals"].to_i}.to_f/ scores.length}
    end
  end

  def team_info(team_id)
    teams_hash = teams_data.group_by {|row| row}.map {|key, value| Hash[key]}.find {|team| team["team_id"] == team_id}
    teams_hash.delete("Stadium")
    teams_hash["franchise_id"] = teams_hash.delete("franchiseId")
    teams_hash["team_name"] = teams_hash.delete("teamName")
    teams_hash
  end



  def most_goals_scored(team_id)
    goals_scored = away_goals_high + home_goals_high
    goals_scored.map {|team_scores| team_scores[team_id]}.compact.max
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
######

  def fewest_goals_scored(team_id)
    goals_scored_few = away_goals_low + home_goals_low
    goals_scored_few.map {|team_scores| team_scores[team_id]}.compact.min
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

#Start of helper methods for winningest coach and worst coach
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

#Start of helper methods for best season and worst season
  def season_ids
    @games_data.map { |row| row["season"] }.uniq
  end

  def win_totals_by_season(season_id)
    data_by_season(season_id).each_with_object(Hash.new(0)) do |row, hash|
      if row["result"] == "WIN"
        hash[row["team_id"]] += 1
      else
        hash[row["team_id"]] += 0
      end
    end
  end

  def total_games_played_by_season(season_id)
    data_by_season(season_id).each_with_object(Hash.new(0)) do |row, hash|
      hash[row["team_id"]] += 1
    end
  end

  def team_percentage_wins_by_season(team_id, season_id)
    (win_totals_by_season(season_id)[team_id] / total_games_played_by_season(season_id)[team_id].to_f).round(3)
  end

  def team_percentage_wins_all_seasons(team_id)
    season_ids.each_with_object({}) do |season_id, hash|
      hash[season_id] = team_percentage_wins_by_season(team_id, season_id)
    end
  end

  def best_season(team_id)
    hash = team_percentage_wins_all_seasons(team_id)
    hash.key(hash.values.max)
  end

  def worst_season(team_id)
    hash = team_percentage_wins_all_seasons(team_id)
    hash.key(hash.values.min)
  end

  def count_of_games_by_season
    games_by_season = Hash.new(0)
    @games_data.each do |row|
      games_by_season[row["season"]] = games_by_season[row["season"]] + 1
    end
    games_by_season
  end

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


#Start of helper methods for rival and favorite opponent methods
  def game_ids_by_team(team_id)
    @games_data.each_with_object([]) do |row, array|
      array << row["game_id"] if row["away_team_id"] == team_id || row["home_team_id"] == team_id
    end
  end

  def opponents_data(team_id)
    games = game_ids_by_team(team_id)
    @game_teams_data.each_with_object([]) do |row, array|
      array << row if games.include?(row["game_id"]) && row["team_id"] != team_id
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
