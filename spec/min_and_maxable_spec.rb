require './lib/min_and_maxable'
require './lib/stat_tracker'

RSpec.describe MinAndMaxable do
  it 'key_at_max takes hash and returns a key at max value' do
    stat_tracker = StatTracker.new(1,2,3)
    hash = {"TeamAmanda" => 1, "TeamEmily" => 2, "TeamPatricia" => 6}
    expect(stat_tracker.key_at_max(hash)).to eq("TeamPatricia")
  end

  it 'key_at_min takes hash and returns a key at min value' do
    stat_tracker = StatTracker.new(1,2,3)
    hash = {"TeamAmanda" => 1, "TeamEmily" => 2, "TeamPatricia" => 6}
    expect(stat_tracker.key_at_min(hash)).to eq("TeamAmanda")
  end
end
