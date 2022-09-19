require 'spec_helper.rb'
require './lib/game_teams'
require 'csv'

RSpec.describe GameTeams do 
  before(:each) do 
    dummy_game_teams_path = './data/dummy_game_teams.csv'
    game_teams_data = CSV.read dummy_game_teams_path, headers:true
    @game_teams = GameTeams.new(game_teams_data) 
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
    it '#data_by_season' do 
      
    end
  end





end
#season a child class of games 