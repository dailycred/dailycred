require 'gems'
require 'pp'
total = 0
Gems.versions('dailycred').reverse.each_with_index do |v,i|
  p "version: #{v['number']}"
  p "downloads: #{v['downloads_count']}"
  total += v['downloads_count']
  p "total: #{total}"
  p "release date: #{Date.parse(v['built_at']).to_time.strftime('%m/%d/%Y')}"
  p "----------"
end