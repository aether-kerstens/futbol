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
end