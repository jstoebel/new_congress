require 'json'
require './race'

races = JSON.parse(File.read('./data/all_races.json'))

hashes = races.map do |race_data|
  race = Race.new(race_data['raceid'], race_data['candidates'])
  race.run
  results = race.results
  {
    id: race.race_id,
    D: results['D'],
    R: results['R'],
    GR: results['GR'],
    LB: results['LB'],
    C: results['C'],
    O: results['O'],
    I: results['I']
  }
end

# I know, I know, this is a bad practice in almost all cases.
# But this is just a script to process data, so relax. 
class Array
  def to_csv(csv_filename = "hash.csv")
    require "csv"
    CSV.open(csv_filename, "wb") do |csv|
      keys = first.keys
      # header_row
      csv << keys
      self.each do |hash|
        csv << hash.values_at(*keys)
      end
    end
  end
end

hashes.to_csv
