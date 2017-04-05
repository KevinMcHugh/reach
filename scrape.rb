require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'
require 'pry'

def process(row, timeout=2)
  base_url = 'http://www.ufc.com/fighter'
  puts row['name']
  url = "#{base_url}/#{(row['name'] || "").gsub(" ", "-")}"
  html = open(url, read_timeout: timeout)
  doc = Nokogiri::HTML(html)
  reach = doc.css("#fighter-reach").text.to_f
  leg_reach = doc.css("#fighter-leg-reach").text.to_f
  row.to_h.merge('reach' => reach.zero? ? nil : reach, 'leg_reach' => leg_reach.zero? ? nil : leg_reach)
end


rows = []
misses = []
csv = CSV.foreach('ALL_UFC_FIGHTERS.csv', headers: true) do |row|
  begin
    rows << process(row)
    puts rows.last
  rescue OpenURI::HTTPError, Net::ReadTimeout
    puts (row['name'] || "").gsub(" ", "-")
    misses << row
  end
end

# misses.each do |row|
#   process(row, 10)
  # rescue OpenURI::HTTPError, Net::ReadTimeout
    # puts "giving up on #{row['name']}"
# end

CSV.open('augmented_fighters.csv', 'wb') do |file|
  file << rows.first.keys
  rows.each do |row|
    file << row.to_h.values
  end
end
