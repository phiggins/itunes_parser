#encoding: utf-8

require 'itunes_parser/mock_xml'

describe ItunesParser::MockXML do
  it "generates XML with no parameters" do
    ItunesParser::MockXML.generate.should == <<XML
#{ItunesParser::MockXML::HEADER}
  <key>Tracks</key>
  <dict>
  </dict>
  <key>Playlists</key>
  <array>
  </array>
#{ItunesParser::MockXML::FOOTER}
XML
  end

  it "generates XML with an arrays of track and playlist hashes" do
    tracks      = [ { "Name"        => "Trapped", 
                      "Artist"      => "Boards of Canada",
                      "Album"       => "A Few Old Tracks",
                      "Bitrate"     => 128,
                      "Date Added"  => "2007-02-15T20:48:01Z",
                      "Explicit"    => true },
                    { "Name"        => "Fak!!!",
                      "Artist"      => "Truckasaurus",
                      "Album"       => "Tea Parties, Guns & Valor",
                      "Bitrate"     => 192,
                      "Date Added"  => "2009-06-11T01:13:21Z" } ]

    playlists   = [ { "Name"        => "Library",
                      "Master"      => true,
                      "Visible"     => false },
                    { "Name"        => "90’s Music" } ]
    mock_xml = ItunesParser::MockXML.new(:tracks => tracks, :playlists => playlists)

    mock_xml.generate.should == <<XML
#{ItunesParser::MockXML::HEADER}
  <key>Tracks</key>
  <dict>
    <key>1</key>
    <dict>
      <key>Track ID</key><integer>1</integer>
      <key>Name</key><string>Trapped</string>
      <key>Artist</key><string>Boards of Canada</string>
      <key>Album</key><string>A Few Old Tracks</string>
      <key>Bitrate</key><integer>128</integer>
      <key>Date Added</key><date>2007-02-15T20:48:01Z</date>
      <key>Explicit</key><true/>
    </dict>
    <key>2</key>
    <dict>
      <key>Track ID</key><integer>2</integer>
      <key>Name</key><string>Fak!!!</string>
      <key>Artist</key><string>Truckasaurus</string>
      <key>Album</key><string>Tea Parties, Guns &amp; Valor</string>
      <key>Bitrate</key><integer>192</integer>
      <key>Date Added</key><date>2009-06-11T01:13:21Z</date>
    </dict>
  </dict>
  <key>Playlists</key>
  <array>
    <dict>
      <key>Name</key><string>Library</string>
      <key>Master</key><true/>
      <key>Visible</key><false/>
      <key>Playlist Items</key>
      <array>
        <dict>
          <key>Track ID</key><integer>1</integer>
        </dict>
        <dict>
          <key>Track ID</key><integer>2</integer>
        </dict>
      </array>
    </dict>
    <dict>
      <key>Name</key><string>90&#8217;s Music</string>
      <key>Playlist Items</key>
      <array>
        <dict>
          <key>Track ID</key><integer>1</integer>
        </dict>
        <dict>
          <key>Track ID</key><integer>2</integer>
        </dict>
      </array>
    </dict>
  </array>
#{ItunesParser::MockXML::FOOTER}
XML
  end

  it "generates dummy data when passed integers" do
    mock_xml = ItunesParser::MockXML.new(:tracks => 2, :playlists => 2)
  
    mock_xml.generate.should == <<XML
#{ItunesParser::MockXML::HEADER}
  <key>Tracks</key>
  <dict>
    <key>1</key>
    <dict>
      <key>Track ID</key><integer>1</integer>
      <key>Name</key><string>Test song name 1</string>
      <key>Artist</key><string>Test artist name 1</string>
      <key>Album</key><string>Test album name 1</string>
      <key>Genre</key><string>Test genre 1</string>
      <key>Kind</key><string>MPEG audio file</string>
      <key>Size</key><integer>1</integer>
      <key>Total Time</key><integer>1</integer>
      <key>Track Number</key><integer>1</integer>
      <key>Track Count</key><integer>1</integer>
      <key>Date Modified</key><date>2005-06-27T23:23:32Z</date>
      <key>Date Added</key><date>2007-02-15T20:51:44Z</date>
      <key>Bit Rate</key><integer>1</integer>
      <key>Sample Rate</key><integer>1</integer>
      <key>Persistent ID</key><string>FB6DB887866AB5C5</string>
      <key>Track Type</key><string>File</string>
      <key>Location</key><string>file://localhost/C:/path/to/my/music/boy/this/path/has/lots/of/subfolders</string>
      <key>File Folder Count</key><integer>-1</integer>
      <key>Library Folder Count</key><integer>-1</integer>
    </dict>
    <key>2</key>
    <dict>
      <key>Track ID</key><integer>2</integer>
      <key>Name</key><string>Test song name 2</string>
      <key>Artist</key><string>Test artist name 2</string>
      <key>Album</key><string>Test album name 2</string>
      <key>Genre</key><string>Test genre 2</string>
      <key>Kind</key><string>MPEG audio file</string>
      <key>Size</key><integer>2</integer>
      <key>Total Time</key><integer>2</integer>
      <key>Track Number</key><integer>2</integer>
      <key>Track Count</key><integer>2</integer>
      <key>Date Modified</key><date>2005-06-27T23:23:32Z</date>
      <key>Date Added</key><date>2007-02-15T20:51:44Z</date>
      <key>Bit Rate</key><integer>2</integer>
      <key>Sample Rate</key><integer>2</integer>
      <key>Persistent ID</key><string>FB6DB887866AB5C5</string>
      <key>Track Type</key><string>File</string>
      <key>Location</key><string>file://localhost/C:/path/to/my/music/boy/this/path/has/lots/of/subfolders</string>
      <key>File Folder Count</key><integer>-1</integer>
      <key>Library Folder Count</key><integer>-1</integer>
    </dict>
  </dict>
  <key>Playlists</key>
  <array>
    <dict>
      <key>Name</key><string>Test playlist 1</string>
      <key>Playlist ID</key><integer>1</integer>
      <key>Playlist Persistent ID</key><string>9D46E5C53E789370</string>
      <key>All Items</key><true/>
      <key>Smart Info</key><string>AQEAAwAAAAIAAAAZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAA==</string>
      <key>Smart Criteria</key><string>U0xzdAABAAEAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAAEAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEAAAAAAAAB8YAAAAAAAAAAAAAAAAAAAAB
      AAAAAAAAB88AAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA=</string>
      <key>Playlist Items</key>
      <array>
        <dict>
          <key>Track ID</key><integer>1</integer>
        </dict>
        <dict>
          <key>Track ID</key><integer>2</integer>
        </dict>
      </array>
    </dict>
    <dict>
      <key>Name</key><string>Test playlist 2</string>
      <key>Playlist ID</key><integer>2</integer>
      <key>Playlist Persistent ID</key><string>9D46E5C53E789370</string>
      <key>All Items</key><true/>
      <key>Smart Info</key><string>AQEAAwAAAAIAAAAZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAA==</string>
      <key>Smart Criteria</key><string>U0xzdAABAAEAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAAEAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEAAAAAAAAB8YAAAAAAAAAAAAAAAAAAAAB
      AAAAAAAAB88AAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA=</string>
      <key>Playlist Items</key>
      <array>
        <dict>
          <key>Track ID</key><integer>1</integer>
        </dict>
        <dict>
          <key>Track ID</key><integer>2</integer>
        </dict>
      </array>
    </dict>
  </array>
#{ItunesParser::MockXML::FOOTER}
XML
    
  end

  it "writes XML to a target object" do
    require 'stringio'
    target = ""
    s = StringIO.new(target)
    ItunesParser::MockXML.generate(:target => target)
    target.should == <<XML
#{ItunesParser::MockXML::HEADER}
  <key>Tracks</key>
  <dict>
  </dict>
  <key>Playlists</key>
  <array>
  </array>
#{ItunesParser::MockXML::FOOTER}
XML
  end
end
