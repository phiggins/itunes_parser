require '../lib/itunes_mock.rb'

file = ARGV.shift
n = ARGV.shift.to_i || 10_000

file ||= "test_xml_#{n}.xml"

puts "generating file '#{file}' with #{n} fake tracks."

tracks = (0...n).map do |i|
  { "Name"          => "Test song name #{i}",
    "Artist"        => "Test artist name #{i}",
    "Album"         => "Test album name #{i}",
    "Genre"         => "Test genre #{i}",
    "Kind"          => "MPEG audio file",
    "Size"          => i,
    "Total Time"    => i,
    "Track Number"  => i,
    "Track Count"   => i,
    "Date Modified" => "2005-06-27T23:23:32Z",
    "Date Added"    => "2007-02-15T20:51:44Z",
    "Bit Rate"      => i,
    "Sample Rate"   => i,
    "Persistent ID" => "FB6DB887866AB5C5",
    "Track Type"    => "File",
    "Location"      => "file://localhost/C:/path/to/my/music/boy/this/path/has/lots/of/subfolders",
    "File Folder Count"     => -1,
    "Library Folder Count"  => -1
  }
end

p_n = [ (n * 0.01).floor, 5 ].max
playlists = (0...n).map do |i|
  { "Name" => "Test playlist #{i}", 
		"Playlist ID" => i,
		"Playlist Persistent ID" => "9D46E5C53E789370",
		"All Items" => true,
		"Smart Info" => "AQEAAwAAAAIAAAAZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAA==",
		"Smart Criteria" =>"U0xzdAABAAEAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAAEAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEAAAAAAAAB8YAAAAAAAAAAAAAAAAAAAAB
			AAAAAAAAB88AAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  }
end

File.open(file, "w") do |f| 
  f << ItunesMock.generate(:tracks => tracks, :playlists => playlists)
end

puts "Generated #{File.size(file)/1024.0/1024.0} MB xml file."
