class Party

  # maps the two major parties to the third party counterparts
  MAJOR_TO_MINOR = { 'D' => 'G', 'R' => 'L' }

  attr_reader :id, :seats_won
  def initialize(id, votes)
    @id = id
    @votes = votes
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
    Party.new MAJOR_TO_MINOR[id], 0
  end
end
