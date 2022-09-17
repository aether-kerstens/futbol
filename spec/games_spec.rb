require 'spec_helper.rb'
require './lib/games'
require 'csv'


RSpec.describe Games do
  before(:each) do 
    dummy_game_path = './data/dummy_games.csv'
    games_data = CSV.read dummy_game_path, headers:true 
    @games = Games.new(games_data) 
  end


  describe '#initialize' do 
    it 'exists' do 
      expect(@games).to be_an_instance_of(Games)
    end 
  end


  describe 'percentage wins and ties helper methods' do
    it 'has a total_home_wins which calculates total number of home wins' do
      expect(@games.total_home_wins).to eq 8
    end

    it 'has a total_away_wins which calculates total number of away wins' do
      expect(@games.total_away_wins).to eq 6
    end

    it 'has a total_ties which calculates total numeber of ties' do
      expect(@games.total_ties).to eq 1
    end

    it 'has a total_games which counts the total number of games' do
      expect(@games.total_games).to eq 15
    end
  end 





  
end