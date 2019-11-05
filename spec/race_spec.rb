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

          expect(race.results).to eq('D' => 3, 'R' => 1, 'GR' => 1)
      end
    end

    context 'uncontested by other major party' do
      it 'awards one seat to other major party if third party does not win two' do

        # by votes alone L should get 1 seat
        race = Race.new('some district',
          [
            { 'party' => 'D', 'votes' => 80 },
            { 'party' => 'LB', 'votes' => 20}
          ])

        race.run

        expect(race.results).to eq('D' => 3, 'LB' => 1, 'R' => 1)
      end
    end
  end

  describe 'adjusting for third parties' do
    it 'doubles vote count for third parties and subtracts 50% from coalition major party'
  end

end
