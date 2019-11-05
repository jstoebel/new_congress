require 'spec_helper'
require './party'

describe Party do

  describe 'effective_votes' do
    it 'computes effective votes for no seats won' do
      party = Party.new 'X', 100
      stub_seats_won(party, 0)
      expect(party.effective_votes).to eq(100)
    end

    it 'computes effective votes for 1 seat won' do
      party = Party.new 'X', 100
      stub_seats_won(party, 1)
      expect(party.effective_votes).to eq(50)
    end

    it 'computes effective votes for 2 seats won' do
      party = Party.new 'X', 100
      stub_seats_won(party, 2)
      expect(party.effective_votes).to eq(33)
    end
  end

  describe 'award' do
    it 'increments seats_won by 1 by default' do
      party = Party.new 'X', 100
      party.award
      expect(party.seats_won).to eq(1)
    end

    it 'increments seats won by n based on argument' do
      party = Party.new 'X', 100
      party.award(2)
      expect(party.seats_won).to eq(2)
    end
  end

  describe '#null_opposing_major' do
    it 'creates a party instance with zero votes' do
      party = Party.new('D', 100)

      opposing_major = party.null_opposing_major

      expect(opposing_major.id).to eq('R')
      expect(opposing_major.instance_variable_get(:@votes)).to eq(0)
    end
  end

  describe '#null_coalition_minor' do
    it 'creates a party instance with zero votes' do
      party = Party.new('D', 100)

      opposing_major = party.null_coalition_minor

      expect(opposing_major.id).to eq('GR')
      expect(opposing_major.instance_variable_get(:@votes)).to eq(0)
    end
  end

  describe 'third_party?' do
    it 'returns false for D' do
      d = Party.new('D', 100)

      expect(d.third_party?).to be_falsy
    end

    it 'returns false for R' do
      r = Party.new('R', 100)

      expect(r.third_party?).to be_falsy

    end

    it 'returns true for all others' do
      other = Party.new('other', 100)

      expect(other.third_party?).to be_truthy

    end
  end

  describe 'natural_leader_id' do
    it 'returns D for green' do
      # this would be R or D
      green = Party.new('GR', 10)
      expect(green.natural_leader_id).to eq('D')
    end

    it 'returns R for Libertarian' do
      libertarian = Party.new('LB', 10)
      expect(libertarian.natural_leader_id).to eq('R')
    end

    it 'returns R for Conservative' do
      libertarian = Party.new('C', 10)
      expect(libertarian.natural_leader_id).to eq('R')
    end
  end

  describe 'steal' do
    before(:each) do
      @green = Party.new('GR', 10)
      @dem = Party.new('D', 90)
      @green.steal(1.0, @dem)
    end
    it 'adds n% of votes from party' do
      expect(@green.instance_variable_get(:@votes)).to eq(20)
    end

    it 'deducts n% of notes from other party' do
      expect(@dem.instance_variable_get(:@votes)).to eq(80)
    end
  end

  def stub_seats_won(party, seats)
    allow(party).to receive(:seats_won).and_return(seats)
  end
end
