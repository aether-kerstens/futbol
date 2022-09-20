require 'spec_helper.rb'

RSpec.describe Season do
  before(:each) do
    dummy_game_path = './data/dummy_games.csv'
    games_data = CSV.read dummy_game_path, headers:true
    @season = Season.new(games_data, "20122013")
  end

  describe '#list_of_game_ids' do
    it 'returns a list of game ids for this season, inherited from the Games class' do
      expected_ids = ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225", "2012030311", "2012030312", "2012030313", "2012030314"]
      expect(@season.list_of_game_ids).to eq(expected_ids)
    end
  end
end
