require 'spec_helper.rb'

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
    it 'has a #total_home_wins which calculates total number of home wins' do
      expect(@games.total_home_wins).to eq 8
    end

    it 'has a #total_away_wins which calculates total number of away wins' do
      expect(@games.total_away_wins).to eq 6
    end

    it 'has a #total_ties which calculates total numeber of ties' do
      expect(@games.total_ties).to eq 1
    end

    it 'has a #total_games which counts the total number of games' do
      expect(@games.total_games).to eq 15
    end
  end

  describe "#list of game ids" do
    it 'returns an array of games_ids' do
      expected_ids = ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225", "2012030311", "2012030312", "2012030313", "2012030314", "2017030211", "2017030212", "2017030213", "2017030214", "2017030215", "2017021257"]
      expect(@games.list_of_game_ids).to eq(expected_ids) 
    end
  end

  describe 'highest scoring visitor helper methods' do
    it 'writes tests for highest scoring visitor #high_ave_score_team helper method' do
      expect(@games.high_ave_score_away).to eq(["6"])
    end

    it 'writes tests for highest scoring visitor #low_ave_score_hometeam helper method' do
      expect(@games.low_ave_score_hometeam).to eq(["5"])
    end

    it 'ave_score_home' do
      expect(@games.ave_score_home).to eq([{"6"=>2.2857142857142856}, {"3"=>1.5}, {"5"=>0.5}, {"14"=>2.3333333333333335}, {"4"=>3.0}])
    end

    it 'high_ave_score_hometeam' do
      expect(@games.high_ave_score_hometeam).to eq(["4"])
    end
  end

  describe '#lowest_scoring_visitor, #highest_scoring_visitor, #lowest_scoring_hometeam, #highest_scoring_hometeam helper methods' do
    it '#low_ave_score_away returns the lowest scoring teams team_id' do
      expect(@games.low_ave_score_away).to eq(["5"])
    end

    it '#ave_score_away finds each team_ids average for scores for all games when away' do
      expect(@games.ave_score_away).to eq([{"3"=>1.25}, {"6"=>2.7142857142857144}, {"5"=>0.5}, {"14"=>2.0}])
    end

    it '#away_goals_high finds highest number of goals for each team_id to help most_goals_scored when away' do
      expect(@games.away_goals_high).to eq([{"3"=>2}, {"6"=>4}, {"5"=>1}, {"14"=>2}])
    end

    it 'finds lowest number of goals for each team_id to help fewest goals scored when away' do
      expect(@games.away_goals_low).to eq([{"3"=>0}, {"6"=>1}, {"5"=>0}, {"14"=>2}])
    end

    it 'finds highest number of goals for each team_id to help most_goals_scored when home' do
      expect(@games.home_goals_high).to eq([{"6"=>3}, {"3"=>2}, {"5"=>1}, {"14"=>3}, {"4"=>3}])
    end

    it 'finds lowest number of goals for each team_id to help most_goals_scored when home' do
      expect(@games.home_goals_low).to eq([{"6"=>1}, {"3"=>1}, {"5"=>0}, {"14"=>2}, {"4"=>3}])
    end

    it 'has a game_ids_by_team method which returns an array of games played by the team' do
      expect(@games.game_ids_by_team('3')).to eq ['2012030221', '2012030222', '2012030223', '2012030224', '2012030225', '2017021257']
    end
  end
end
