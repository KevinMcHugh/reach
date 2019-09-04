require 'gruff'
require 'csv'

rows = CSV.parse(File.read('augmented_fighters.csv'), headers: true).sort { |row| row['weight'].to_f }

g = Gruff::Scatter.new
g.labels
g.title = 'All Weightclasses'
have_both = rows.find_all { |row| row['height'] && row['reach_to_height'] }
by_weightclass = have_both.group_by { |row| row['class'].gsub(/\s+/, "")  }
weightclasses = %w( Flyweight Featherweight Lightweight Welterweight Middleweight LightHeavyweight Heavyweight)
weightclasses.each do |weightclass|
  fighters = by_weightclass[weightclass]
  puts "#{weightclass}: #{fighters.count}"
  heights = fighters.map { |row| row['height'] }.compact.map(&:to_f)
  ratios = fighters.map {|row| row['reach_to_height'] }.compact.map(&:to_f)
  g.data weightclass, heights, ratios
end
g.write 'ratio.png'

h = Gruff::Scatter.new
h.title = 'All Weightclasses'
weightclasses.each do |weightclass|
  fighters = by_weightclass[weightclass]
  heights = fighters.map { |row| row['height'] }.compact.map(&:to_f)
  reachs = fighters.map {|row| row['reach'] }.compact.map(&:to_f)
  h.data weightclass, heights, reachs
end
h.write 'height.png'

weightclasses.each do |weightclass|
  wc_ratio = Gruff::Scatter.new
  wc_ratio.hide_legend = true
  wc_ratio.title = weightclass
  fighters = by_weightclass[weightclass]
  fighters.each do |fighter|
    wc_ratio.data fighter['name'], [fighter['height'].to_f], [fighter['reach_to_height'].to_f]
  end
  wc_ratio.write "#{weightclass}-ratio.png"

  wc_reach = Gruff::Scatter.new
  wc_reach.hide_legend = true
  wc_reach.title = weightclass
  fighters = by_weightclass[weightclass]
  fighters.each do |fighter|
    wc_reach.data fighter['name'], [fighter['height'].to_f], [fighter['reach'].to_f]
  end
  wc_reach.write "#{weightclass}-reach.png"
end