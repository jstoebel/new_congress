require 'spec_helper'
require './race'

describe Race do
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

  describe 'uncontested' do

    context 'completly uncontested' do
      it 'awards one seat to third party and one to other major party ' do
        race = Race.new('some district',
          [
            { 'party' => 'D', 'votes' => 100 },
          ])

          race.run

          expect(race.results).to eq('D' => 3, 'R' => 1, 'G' => 1)
      end
    end

    context 'uncontested by other major party' do
      it 'other major party wins one seat if third party does not win two'
    end
  end

  describe 'adjusting for third parties' do
    it 'doubles vote count for third parties and subtracts 50% from centrist party'
  end

end
