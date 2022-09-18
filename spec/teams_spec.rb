require 'spec_helper.rb'
require './lib/teams'
require 'csv'


RSpec.describe Teams do 
  before(:each) do 
    dummy_team_path = './data/dummy_teams.csv'
    teams_data = CSV.read dummy_team_path, headers:true 
    @teams = Teams.new(teams_data) 
  end

end