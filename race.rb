require './party'
# represents a single congressional race
class Race

  REPS_PER_DISTRICT = 5

  # maps the two major parties to the third party counterparts
  MAJOR_TO_MINOR = { 'D' => 'G', 'R' => 'L' }
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
    if @parties.one?
      handle_completly_uncontested!
    else
      REPS_PER_DISTRICT.times do
        @parties
          .sort_by(&:effective_votes) # sort by effective votes
          .last.award # inform the winner
      end
    end
  end

  # print results
  def results
    @parties
      .sort_by(&:effective_votes)
      .each_with_object({}) { |party, memo| memo[party.id] = party.seats_won }
  end

  private

  # how to handle a completly uncontested race
  def handle_completly_uncontested!

    # sole party get three seats
    sole_party = @parties.first
    sole_party.award(3)

    # one seat to other major party
    other_major_id =( MAJOR_TO_MINOR.keys - [sole_party.id]).first
    other_major = Party.new( other_major_id, 0 )
    other_major.award(1)
    @parties << other_major

    # one seat to third party
    third_party = Party.new( MAJOR_TO_MINOR[sole_party.id], 0 )
    third_party.award(1)
    @parties << third_party
  end
end
