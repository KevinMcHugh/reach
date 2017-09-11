require 'csv'
require 'pry'

rows = CSV.parse(File.read('augmented_fighters.csv'), headers: true)
by_height = rows.group_by { |r| r['height'] }
by_height.delete(nil)
avg_reach_by_height = by_height.keep_if { |k,v| v.any?}.map do |k, vals|
  sum = vals.keep_if { |r| r['reach'] }.map { |r| r['reach'].to_f }.reduce(:+) || 0
  if vals.any?
    { height: k, avg_reach: sum/vals.count || 1 }
  else
    nil
  end
end.compact
avg_reach_by_height.map { |h| {h[:height] => h[:avg_reach] / h[:height].to_i } }
# binding.pry
puts by_height.values.flatten.find_all {|v| v['reach_to_height'].to_f > 1.1 }.map { |v| v['name'] }