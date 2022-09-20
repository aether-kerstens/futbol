require_relative 'spec_helper.rb'

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
    it '#team_id_to_name returns a list of team_ids and associated names' do
      expect(@teams.team_id_to_name).to eq(
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

  describe 'helper method that takes a team_id and returns a string of a name' do
    it 'has #get_team_name which takes a team_id and returns string of team name' do
      expect(@teams.get_team_name('3')).to eq 'Houston Dynamo'
    end
  end

  describe '#team_info' do
    it 'gives #team_info in a hash with input of team_id' do
      expect(@teams.team_info('1')).to eq({
        'team_id'  => '1',
        'franchise_id' => '23',
        'team_name' => 'Atlanta United',
        'abbreviation' => 'ATL',
        'link' => '/api/v1/teams/1'})
    end
  end
end
