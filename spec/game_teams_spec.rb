require 'spec_helper.rb'
require './lib/game_teams'
require './lib/season'
require 'csv'

RSpec.describe GameTeams do 
  before(:each) do 
    dummy_game_teams_path = './data/dummy_game_teams.csv'
    game_teams_data = CSV.read dummy_game_teams_path, headers:true
    dummy_games_path = './data/dummy_games.csv'
    games_data = CSV.read dummy_games_path, headers:true
    @game_teams = GameTeams.new(game_teams_data, games_data) 
  end

  describe 'initialize' do 
    it 'exists' do 
      expect(@game_teams).to be_an_instance_of(GameTeams)
    end
  end

  describe 'helper method for best offense, worst offense' do 
    #write tests for count_of_games_by_team, count_of_goals_by_team, average_goals_by_team
  end

  describe 'gets data in game_teams by season' do 

    it 'has data_by_season which returns an array of game_teams_data rows' do
      expect(@game_teams.data_by_season('20122013')).to be_an Array
      coaches = @game_teams.data_by_season('20122013').map { |row| row['head_coach'] }
      expect(coaches).to eq ['John Tortorella', 'Claude Julien', 'John Tortorella', 'Claude Julien', 'Claude Julien', 'John Tortorella',
                             'Claude Julien', 'John Tortorella', 'John Tortorella', 'Claude Julien', 'Claude Julien', 'Dan Bylsma',
                             'Claude Julien', 'Dan Bylsma', 'Dan Bylsma', 'Claude Julien', 'Dan Bylsma', 'Claude Julien']
    end
  end

  describe '#wins_by_coach' do 
    it 'returns hash with coach key and no. wins value' do
      expect(@game_teams.wins_by_coach('20122013')).to be_a Hash
      expect(@game_teams.wins_by_coach('20122013')['John Tortorella']).to eq 0
      expect(@game_teams.wins_by_coach('20122013')['Claude Julien']).to eq 9
    end
  end





end
#season a child class of games 