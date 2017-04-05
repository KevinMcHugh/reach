rows = CSV.parse(File.read('augmented_fighters.csv'), headers: true)
by_height = rows.group_by { |r| r['height'] }
by_height.delete(nil)
by_height.keep_if { |k,v| v.any?}.map do |k, vals|
  sum = vals.keep_if { |r| r['reach'] }.map { |r| r['reach'].to_f }.reduce(:+) || 0
  { height: k, avg_reach: sum/vals.count }
end
avg_reach_by_height = by_height.keep_if { |k,v| v.any?}.map do |k, vals|
  sum = vals.keep_if { |r| r['reach'] }.map { |r| r['reach'].to_f }.reduce(:+) || 0
  { height: k, avg_reach: sum/vals.count }
end
avg_reach_by_height.map { |h| {h[:height] => h[:avg_reach] / h[:height].to_i } }