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

  describe '#team_accuracy_by_season' do 
    it 'returns a hash with team key and ratio of goals to shots as value' do 
      expect(@game_teams.team_accuracy_by_season("20122013")).to eq({"3"=>0.21052631578947367, "5"=>0.0625, "6"=>0.3157894736842105})
    end
  end

  describe 'best and worst season helper methods' do
    it 'has win_totals_by_season which returns a hash of team_ids => number of wins' do
      expect(@game_teams.win_totals_by_season('20122013')).to eq({'3'=>0, '6'=>9, '5'=>0})
    end

    it 'has total_games_played_by_season which returns a hash of team_ids => total games played' do
      expect(@game_teams.total_games_played_by_season('20122013')).to eq({'3'=>5, '6'=>9, '5'=>4})
    end

    it 'has team_percentage_wins_by_season which takes a team_id and season_id and returns a percentage' do
      expect(@game_teams.team_percentage_wins_by_season('3', '20122013')).to eq 0.0
      expect(@game_teams.team_percentage_wins_by_season('6', '20122013')).to eq 1.0
    end

    it 'has team_percentage_wins_all_seasons which takes a team_id and returns a hash of season_ids => win percentage' do
      expect(@game_teams.team_percentage_wins_all_seasons('3')).to eq({'20122013'=>0.0, '20172018'=>0.0})
      expect(@game_teams.team_percentage_wins_all_seasons('6')).to eq({'20122013'=>1.0, '20172018'=>0.4})
    end
  end

  describe 'rival and favorite opponent helper methods' do

    it 'has an opponents_data which filters the games_teams_data by opponents of a given team' do
      expect(@game_teams.opponents_data('3')).to be_an Array
      coaches = @game_teams.opponents_data('3').map { |row| row['head_coach'] }
      expect(coaches).to eq ['Claude Julien', 'Claude Julien', 'Claude Julien', 'Claude Julien', 'Claude Julien', 'Dave Hakstol']
    end

    it 'has opponents_win_totals which returns a hash of opponents_ids => win total' do
      expect(@game_teams.opponents_win_totals('3')).to eq({'6'=>5, '4'=>1})
    end

    it 'has opponents_games_totals which returns a hash of opponents_ids => total games' do
      expect(@game_teams.opponents_games_totals('3')).to eq({'6'=>5, '4'=>1})
    end

    it 'has opponents_ids which returns an array of all oppoenents faced by given team' do
      expect(@game_teams.opponents_ids('3')).to eq ['6', '4']
    end

    it 'has all_opponents_win_percentages which returns a hash of opponents_ids => win percentage' do
      expect(@game_teams.all_opponents_win_percentages('6')).to eq({'3'=>0.00, '5'=>0.00, '14'=>0.40})
    end
  end





end
#season a child class of games 