require 'csv'

class Teams 
  def initialize(teams_data)
    @teams_data = teams_data
  end


  def team_id_to_name
    @teams_data.map do |row|
      {row["team_id"] => row["teamName"]}
    end
  end

  def get_team_name(team_id)
    team = @teams_data.find { |row| row["team_id"] == team_id }
    team["teamName"]
  end

  def team_info(team_id)
    teams_hash = @teams_data.group_by {|row| row}.map {|key, value| Hash[key]}.find {|team| team["team_id"] == team_id}
    teams_hash.delete("Stadium")
    teams_hash["franchise_id"] = teams_hash.delete("franchiseId")
    teams_hash["team_name"] = teams_hash.delete("teamName")
    teams_hash
  end

  def count_of_teams
    @teams_data.map { |row| row["teamName"] }.uniq.count
  end
end