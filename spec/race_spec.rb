require 'spec_helper'
require './race'

describe Race do
  it 'awards 5 seats to an uncontested race' do
    race = Race.new('some district',
                    [
                      { 'party' => 'D', 'votes' => 1 }
                    ])

    race.run

    expect(race.results).to eq('D' => 5)
  end

  it 'awards 5 seats to a winner of 100% of the votes' do
    race = Race.new('some district',
      [
        { 'party' => 'D', 'votes' => 100 },
        { 'party' => 'R', 'votes' => 0}
      ])

      race.run

      expect(race.results).to eq('D' => 5, 'R' => 0)
  end

  it 'awards seats correctly for a contested seat' do
    race = Race.new('some district',
      [
        { 'party' => 'D', 'votes' => 89_226 },
        { 'party' => 'R', 'votes' => 153_228 }
      ])

      race.run

      expect(race.results).to eq('D' => 2, 'R' => 3)
  end
end
