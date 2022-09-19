require 'spec_helper.rb'
require './lib/teams'
require 'csv'


RSpec.describe Teams do 
  before(:each) do 
    dummy_team_path = './data/dummy_teams.csv'
    teams_data = CSV.read dummy_team_path, headers:true 
    @teams = Teams.new(teams_data) 
  end

  describe '#initialize' do 
    it 'exists' do 
      expect(@teams).to be_an_instance_of(Teams)
    end
  end

  describe 'helper method for lowest scoring visitor' do 
    it 'returns a list of team_ids and associated names' do 
      expect(@games.team_id_to_name).to eq(
        [{"1"=>"Atlanta United"},
        {"4"=>"Chicago Fire"},
        {"26"=>"FC Cincinnati"},
        {"14"=>"DC United"},
        {"6"=>"FC Dallas"},
        {"3"=>"Houston Dynamo"},
        {"5"=>"Sporting Kansas City"},
        {"17"=>"LA Galaxy"},
        {"28"=>"Los Angeles FC"}]
      )
    end
  end






end