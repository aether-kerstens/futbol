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

  describe "season helper methods" do
    it 'has games_by_season which returns an array of games_ids' do
      expect(@games.games_by_season('20122013')).to eq ['2012030221', '2012030222', '2012030223', '2012030224', '2012030225', '2012030311', '2012030312', '2012030313', '2012030314']
    end
  end




  
end