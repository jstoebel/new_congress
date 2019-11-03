require 'net/http'
require 'json'

races = []
(1..14).each do |i|
  file_name = "H#{i.to_s.rjust(2, '0')}.json"
  puts file_name
  uri = URI("https://data.cnn.com/ELECTION/2018November6/full/#{file_name}")
  data_str = Net::HTTP.get(uri)
  data_h = JSON.parse(data_str)

  races += data_h['races']
end

File.open('all_races.json', 'w+') { |f| f.write races.to_json }
