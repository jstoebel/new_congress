require './party'
# represents a single congressional race
class Race

  REPS_PER_DISTRICT = 5

  attr_reader :race_id
  # raceid (string) the id representing the congresional district. Example: ALH01
  # parties (array of hashes representing the performance of
  # each party). Fields are:
  #   party: a single character. Example 'D'
  #   votes: number of votes won by that party
  def initialize(raceid, parties)
    @race_id = raceid
    @parties = parties.map { |party| Party.new party['party'], party['votes'] }
  end

  # simulate the election using the rules found here
  # http://www.europarl.europa.eu/unitedkingdom/en/european-elections/european_elections/the_voting_system.html
  def run
    if @parties.one?
      handle_completly_uncontested!
    else
      adjust_for_third_parties!
      REPS_PER_DISTRICT.times do
        @parties
          .sort_by(&:effective_votes) # sort by effective votes
          .last.award # inform the winner
      end
      tweak_results!
    end
  end

  # print results
  def results
    @parties
      .sort_by(&:effective_votes)
      .each_with_object({}) { |party, memo| memo[party.id] = party.seats_won }
  end

  private

  # A safe district (so safe it was unopposed in 2018)
  # would become competative in multi member system. A third party in same coalition as the dominant party
  # would likely be able to pick up a seat here
  # as woul the other major party.
  def handle_completly_uncontested!

    # sole party get three seats
    sole_party = @parties.first
    sole_party.award(3)

    # TODO: fix this demeter violation
    other_major = sole_party.null_opposing_major
    other_major.award(1)
    @parties << other_major

    # one seat to third party
    # TODO: fix this demeter violation
    third_party = sole_party.null_coalition_minor
    third_party.award(1)
    @parties << third_party
  end

  # tweak data to account for various corner cases
  def tweak_results!
    # if the race is between a major party and opposing minor party
    # (D v L or R v G), and the end results are 4/1, the absent major party gets
    # 1 seat subracted from the other major party

    # this is a standard R v D race
    return if includes_r_and_d?

    return unless @parties.min_by(&:seats_won).seats_won < 2

    # this race involves a major v minor party but the minor party took just 1 seat.
    # the major party would have run in a multi member district and been able to pick up 1 seat.
    major_party = @parties.max_by(&:seats_won)
    major_party.award(-1)

    # TODO: fix this demeter violation
    other_major = major_party.null_opposing_major
    other_major.award 1

    @parties << other_major
  end

  # is one major party missing from the race?
  def includes_r_and_d?
    party_ids = @parties.map(&:id)
    party_ids.include?('D') && party_ids.include?('R')
  end

  # third parties get their vote counts doubled subtracted from their coalition partner.
  # if third party does not have a coalition partner, subtract from top vote getter.
  def adjust_for_third_parties!
    third_parties = @parties.select(&:third_party?)
    third_parties.each do |third_party|
      third_party.steal(1.0, coalition_leader(third_party))
    end
  end

  # returns the coalition leader for a party
  # parties with a natural leader (GR -> D, LB -> R) return those if they are in the race
  # in all other instances return the top vote getter
  def coalition_leader(party)
    natural_leader = @parties.find {|p| p.id == party.natural_leader_id }
    natural_leader || @parties.max_by(&:seats_won)
  end
end
