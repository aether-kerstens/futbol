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

end