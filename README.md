# itunes_parser
A ruby library for parsing iTunes XML library files based on nokogiri.

### Examples
[Using generated xml.](http://gist.github.com/642010)
#### Regular usage
    >> parser = ItunesParser.new( open("fake_itunes.xml") )
    >> parser.tracks.map {|track| track["Name"] }
    => ["Test song name 0", "Test song name 1", "Test song name 2", "Test song name 3", "Test song name 4"] 
    >> parser.playlists.map {|playlist| playlist["Name"] }
    => ["Test playlist 0", "Test playlist 1", "Test playlist 2", "Test playlist 3", "Test playlist 4"] 

#### With callbacks
    >> file = open("fake_itunes.xml")
    >> on_track = lambda {|track| puts "on_track: #{track["Name"]}" }
    >> ItunesParser.parse(file, :on_track => on_track)
    on_track: Test song name 0
    on_track: Test song name 1
    on_track: Test song name 2
    on_track: Test song name 3
    on_track: Test song name 4

    >> file = open("fake_itunes.xml")
    >> on_playlist = lambda {|p| puts "on_playlist: '#{p["Name"]}' has #{p["Playlist Items".size]} tracks" }
    >> ItunesParser.parse(file, :on_playlist => on_playlist )
    on_playlist: 'Test playlist 0' has 5 tracks
    on_playlist: 'Test playlist 1' has 5 tracks
    on_playlist: 'Test playlist 2' has 5 tracks
    on_playlist: 'Test playlist 3' has 5 tracks
    on_playlist: 'Test playlist 4' has 5 tracks


### Features
* Simple typecasting of values to ruby equivalents.
* Callback parsing mode allows passing blocks called for each element parsed.
* Mock library for easy generation of itunes-like xml for testing.

### Dependencies
* Nokogiri and miniunit for testing. Only tested on ruby 1.9.2.

### Todo
* Map playlists to tracks automatically.
* Test with a wide variety of real input files.
* Profile and optimize.
* Test with versions of ruby other than 1.9.2.
