require './party'
# represents a single congressional race
class Race

  REPS_PER_DISTRICT = 5
  # attr_reader @raceid
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
    REPS_PER_DISTRICT.times do
      @parties
        .sort_by(&:effective_votes) # sort by effective votes
        .last.award # inform the winner
    end
  end

  # print results
  def results
    @parties
      .sort_by(&:effective_votes)
      .each_with_object({}) { |party, memo| memo[party.id] = party.seats_won }
  end
end
