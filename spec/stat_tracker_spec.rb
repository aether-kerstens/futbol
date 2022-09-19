require 'spec_helper.rb'
require './lib/stat_tracker.rb'
require 'csv'

RSpec.describe StatTracker do
  before(:each) do
    dummy_game_path = './data/dummy_games.csv'
    dummy_team_path = './data/dummy_teams.csv'
    dummy_game_teams_path = './data/dummy_game_teams.csv'
    locations = {
                  games: dummy_game_path,
                  teams: dummy_team_path,
                  game_teams: dummy_game_teams_path
                }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  context 'instatiaton' do
    describe '#initialize' do
      it 'exists' do
        expect(StatTracker.new(1, 2, 3)).to be_an_instance_of(StatTracker)
      end
    end

    describe '#self.from_csv' do
      it '#returns an instance of stat_tracker' do
        dummy_game_path = './data/dummy_games.csv'
        dummy_team_path = './data/dummy_teams.csv'
        dummy_game_teams_path = './data/dummy_game_teams.csv'
        locations = {
                      games: dummy_game_path,
                      teams: dummy_team_path,
                      game_teams: dummy_game_teams_path
                    }
        expect(@stat_tracker).to be_an_instance_of(StatTracker)
      end
    end
  end

  context 'game statistics' do
    describe '#highest_total_score' do
      it 'highest sum of winning and losing team scores' do
        expect(@stat_tracker.highest_total_score).to eq 6
      end
    end

    describe '#lowest_total_score' do
      it 'lowest sum of winning and losing teams scores' do
        expect(@stat_tracker.lowest_total_score).to eq 1
      end
    end


    describe '#percentage_home_wins' do
      it 'returns a float rounded to nearest 100th of percentage home wins' do
        expect(@stat_tracker.percentage_home_wins).to eq 0.53
      end
    end

    describe '#percentage_visitor_wins' do
      it 'returns a float rounded to nearest 100th of percentage visitor wins' do
        expect(@stat_tracker.percentage_visitor_wins).to eq 0.40
      end
    end

    describe '#percentage_ties' do
      it 'returns a float rounded to nearest 100th of percentage ties' do
        expect(@stat_tracker.percentage_ties).to eq 0.07
      end
    end

    describe '#count_of_games_by_season'do
      it 'counts games per season' do
        expect(@stat_tracker.count_of_games_by_season).to eq({'20122013'=>9, '20172018'=>6})
      end
    end

    describe '#average_goals_per_game' do
      it 'returns a float rounded to nearest 100th of average goals per game' do
        expect(@stat_tracker.average_goals_per_game).to eq 3.93
      end
    end

    describe '#average_goals_by_season' do
      it 'returns a hash of season => average goals' do
        expect(@stat_tracker.average_goals_by_season).to eq ({"20122013" => 3.78, "20172018" =>4.17})
      end
    end
  end

  context 'league statistics' do
    # describe '#count_of_teams' do
    #   #test goes here
    # end

    describe '#best_offense' do
      it 'returns a string of team with best offense' do
        expect(@stat_tracker.best_offense).to eq("Chicago Fire")
      end
    end

    describe '#worst_offense' do
      it 'returns a string of team with worst offense' do
        expect(@stat_tracker.worst_offense).to eq("Sporting Kansas City")
      end
    end

    describe '#highest_scoring_visitor' do
      it 'highest_scoring_visitor, name of team with highest avg score per game' do
        expect(@stat_tracker.highest_scoring_visitor).to eq('FC Dallas')
      end


    end

    describe 'highest_scoring_home_team' do
      it 'highest_scoring_home_team, name of team with highest avg score per game' do
        expect(@stat_tracker.highest_scoring_home_team).to eq('Chicago Fire')
      end
    end

    describe '#lowest_scoring_visitor' do
      it 'returns name of team with lowest avg score per game' do
        expect(@stat_tracker.lowest_scoring_visitor).to eq('Sporting Kansas City')
      end

    end 

    describe '#lowest_scoring_home_team' do
      it 'returns name of team with lowest average score while at home' do
        expect(@stat_tracker.lowest_scoring_home_team).to eq('Sporting Kansas City')
      end
    end
  end

  context 'season statistics' do
    describe '#winningest_coach' do
      it 'has winningest_coach which returns the name of winningest coach as a string' do
        expect(@stat_tracker.winningest_coach('20122013')).to eq 'Claude Julien'
      end
    end

    describe '#worst_coach' do
      it 'has worst_coach which returns the name of the worst coach as a string' do
        expect(@stat_tracker.worst_coach('20122013')).to eq 'John Tortorella'
      end
    end

    describe '#most_accurate_team' do
      it "returns the name of the most accurate team" do
        expect(@stat_tracker.most_accurate_team('20122013')).to eq("FC Dallas")
      end
    end

    describe '#least_accurate_team' do
      it "returns the name of the least accurate team" do
        expect(@stat_tracker.least_accurate_team('20122013')).to eq("Sporting Kansas City")
      end
    end

    describe '#most_tackles' do
      it 'returns the name of team with most tackles by season' do
        expect(@stat_tracker.most_tackles('20122013')).to eq 'FC Dallas'
      end
    end

    describe '#fewest_tackles' do
      it 'returns the name of team with fewest tackles by season' do
        expect(@stat_tracker.fewest_tackles('20122013')).to eq 'Sporting Kansas City'
      end
    end
  end

  context 'team statistics' do
    describe '#team_info' do
      it 'gives team_info in a hash with input of team_id' do
        # require 'pry'; binding.pry
        expect(@stat_tracker.team_info('1')).to eq({
          'team_id'  => '1',
          'franchise_id' => '23',
          'team_name' => 'Atlanta United',
          'abbreviation' => 'ATL',
          'link' => '/api/v1/teams/1'})
      end
    end

    describe 'best and worst season helper methods' do
      it 'has win_totals_by_season which returns a hash of team_ids => number of wins' do
        expect(@stat_tracker.win_totals_by_season('20122013')).to eq({'3'=>0, '6'=>9, '5'=>0})
      end

      it 'has total_games_played_by_season which returns a hash of team_ids => total games played' do
        expect(@stat_tracker.total_games_played_by_season('20122013')).to eq({'3'=>5, '6'=>9, '5'=>4})
      end

      it 'has team_percentage_wins_by_season which takes a team_id and season_id and returns a percentage' do
        expect(@stat_tracker.team_percentage_wins_by_season('3', '20122013')).to eq 0.0
        expect(@stat_tracker.team_percentage_wins_by_season('6', '20122013')).to eq 1.0
      end

      it 'has team_percentage_wins_all_seasons which takes a team_id and returns a hash of season_ids => win percentage' do
        expect(@stat_tracker.team_percentage_wins_all_seasons('3')).to eq({'20122013'=>0.0, '20172018'=>0.0})
        expect(@stat_tracker.team_percentage_wins_all_seasons('6')).to eq({'20122013'=>1.0, '20172018'=>0.4})
      end
    end

    describe '#best_season' do
      it 'takes a team_id and returns the season_id with highest win percentage' do
        expect(@stat_tracker.best_season('6')).to eq '20122013'
      end
    end

    describe '#worst_season' do
      it 'team_id and returns the season_id with lowestwin percentage' do
        expect(@stat_tracker.worst_season('6')).to eq '20172018'
      end
    end

    describe 'average_win_percentage' do
      it 'can calculate the win percentage for a team' do
        expect(@stat_tracker.average_win_percentage('3')).to eq(0.0)
      end
    end

    describe '#most goals scored'do
      it 'has most_goals_scored method for highest number of goals for a particular team in a single game' do
        expect(@stat_tracker.most_goals_scored('6')).to eq(4)
      end
    end

    describe '#fewest_goals_scored' do
      it 'has fewest_goals_scored method for lowest number of goals for a particular team in a single game' do
        # require 'pry'; binding.pry
        expect(@stat_tracker.fewest_goals_scored('6')).to eq(1)
      end
    end

    describe 'rival and favorite opponent helper methods' do

      it 'has an opponents_data which filters the games_teams_data by opponents of a given team' do
        expect(@stat_tracker.opponents_data('3')).to be_an Array
        coaches = @stat_tracker.opponents_data('3').map { |row| row['head_coach'] }
        expect(coaches).to eq ['Claude Julien', 'Claude Julien', 'Claude Julien', 'Claude Julien', 'Claude Julien', 'Dave Hakstol']
      end

      it 'has opponents_win_totals which returns a hash of opponents_ids => win total' do
        expect(@stat_tracker.opponents_win_totals('3')).to eq({'6'=>5, '4'=>1})
      end

      it 'has opponents_games_totals which returns a hash of opponents_ids => total games' do
        expect(@stat_tracker.opponents_games_totals('3')).to eq({'6'=>5, '4'=>1})
      end

      it 'has opponents_ids which returns an array of all oppoenents faced by given team' do
        expect(@stat_tracker.opponents_ids('3')).to eq ['6', '4']
      end

      it 'has all_opponents_win_percentages which returns a hash of opponents_ids => win percentage' do
        expect(@stat_tracker.all_opponents_win_percentages('6')).to eq({'3'=>0.00, '5'=>0.00, '14'=>0.40})
      end


    end

    describe '#favorite_opponent' do
      it 'eturns the opponent with the lowest win percentage for the given team' do
        expect(@stat_tracker.favorite_opponent('6')).to eq 'Houston Dynamo'
      end
    end

    describe 'rival' do
      it 'returns the opponent with the highest win percentage for the given team' do
        expect(@stat_tracker.rival('6')).to eq 'DC United'
      end
    end
  end
end
