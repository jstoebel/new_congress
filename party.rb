class Party

  # maps the two major parties to the third party counterparts
  MAJOR_TO_MINOR = { 'D' => ['GR'], 'R' => ['LB', 'C'] }
  MINOR_TO_MAJOR = { 'GR' => 'D', 'LB' => 'R', 'C' => 'R' }

  attr_reader :id, :seats_won
  attr_accessor :votes
  def initialize(id, votes)
    @id = id
    @votes = votes.to_f
    @seats_won = 0
  end

  def effective_votes
    @votes / (seats_won + 1)
  end

  def award(n = 1)
    @seats_won += n
  end

  def null_opposing_major
    null_major_id = ( MAJOR_TO_MINOR.keys - [id]).first
    Party.new null_major_id, 0
  end

  def null_coalition_minor
    Party.new MAJOR_TO_MINOR[id].first, 0
  end

  def third_party?
    !%w[R D].include? id
  end

  def natural_leader_id
    MINOR_TO_MAJOR[id]
  end

  def steal(percent, other_party)
    votes_to_change = votes * percent.to_f
    @votes += votes_to_change

    other_party.votes -= votes_to_change
  end
end
