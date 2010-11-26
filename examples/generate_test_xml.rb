require File.expand_path(File.dirname(__FILE__) + '/../lib/itunes_parser/mock_xml')

n = (ARGV.shift || 10_000).to_i
file = ARGV.shift

file ||= "test_xml_#{n}.xml"

p_n = [ (n * 0.01).floor, 5 ].max

puts "generating file '#{file}' with #{n} fake tracks and #{p_n} fake playlists."

File.open(file, "w") do |f| 
  ItunesParser::MockXML.generate(:tracks => n, :playlists => p_n, :target => f)
end

puts "Generated %.3f MB xml file." % 91.06637954711914
