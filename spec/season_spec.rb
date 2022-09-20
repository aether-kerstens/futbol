require 'spec_helper.rb'

RSpec.describe Season do
  before(:each) do
    dummy_game_path = './data/dummy_games.csv'
    games_data = CSV.read dummy_game_path, headers:true
    @season = Season.new(games_data, "20122013")
  end

  describe 'list of game ids' do
    it 'returns a list of game ids for this season' do
      expect(@season.list_of_game_ids).to eq(["2012030221", "2012030222", "2012030223", "2012030224", "2012030225", "2012030311", "2012030312", "2012030313", "2012030314"])
    end
  end

end
