class Party
  attr_reader :id, :seats_won
  def initialize(id, votes)
    @id = id
    @votes = votes
    @seats_won = 0
  end

  def effective_votes
    @votes / (seats_won + 1)
  end

  def award
    @seats_won += 1
  end
end
