# encoding: utf-8

require 'nokogiri'

module ItunesParser
  class MockXML
    def initialize(params={})
      tracks  = params[:tracks] || []
      @tracks = if tracks.is_a?(Fixnum) 
        self.class.dummy_tracks(tracks)
      else
        tracks
      end
      
      playlists = params[:playlists] || []
      @playlists = if playlists.is_a?(Fixnum)
        self.class.dummy_playlists(playlists)
      else
        playlists
      end

      @target = params[:target] || ""
    end

    def self.generate(*args)
      new(*args).generate
    end

    def generate
      out HEADER
      tracks
      playlists
      out FOOTER
    end

    def out(line, indent=0)
      @target << "#{" " * indent}#{line}\n"
    end

    def tracks
      # Start of Tracks section. Tracks is a dict of dicts.
      out "<key>Tracks</key>", 2
      out "<dict>", 2

      @tracks.each_with_index do |track,i|
        index = i+1
        out "<key>#{index}</key>", 4
        out "<dict>", 4
        out "<key>Track ID</key><integer>#{index}</integer>", 6
        
        track.each do |key,val|
          out "<key>#{key}</key>#{self.class.ruby_to_itunes_type(val)}", 6
        end

        out "</dict>", 4
      end

      out "</dict>", 2
    end

    def playlists
      # Start of Playlist section. Playlists is an array of dicts.
      out "<key>Playlists</key>", 2
      out "<array>", 2

      @playlists.each do |playlist|
        out "<dict>", 4
        
        playlist.each do |key,val|
          out "<key>#{key}</key>#{self.class.ruby_to_itunes_type(val)}", 6
        end
        
        # Playlists with zero tracks do not have a "Playlist Items" section
        if @tracks.size > 0
          out "<key>Playlist Items</key>", 6
          out "<array>", 6
          
          # TODO: All tracks are on all playlists. Figure out something more clever?
          (1..@tracks.size).each do |i|
            out "<dict>", 8
            out "<key>Track ID</key><integer>#{i}</integer>", 10
            out "</dict>", 8
          end

          out "</array>", 6
        end

        out "</dict>", 4
      end

      out "</array>", 2
    end

    # Guess the itunes type from the ruby type
    def self.ruby_to_itunes_type(var)
      case var
      when Fixnum 
        "<integer>#{var}</integer>"
      when false
        "<false/>"
      when true
        "<true/>"
      when /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/
        "<date>#{var}</date>"
      else
        "<string>#{xml_escape(var)}</string>"
      end
    end

    def self.dummy_tracks(n)
      (1..n).map do |i|
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
    end

    def self.dummy_playlists(n)
      (1..n).map do |i|
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
    end

    HEADER = <<HEADER
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Major Version</key><integer>1</integer>
	<key>Minor Version</key><integer>1</integer>
	<key>Application Version</key><string>90.0.1</string>
	<key>Features</key><integer>1</integer>
	<key>Show Content Ratings</key><true/>
	<key>Music Folder</key><string>file://localhost//$SERVER/Users/billcosby/My%20Documents/My%20Music/iTunes/iTunes%20Music/</string>
	<key>Library Persistent ID</key><string>90210PB4UGO2BED</string>
HEADER

    FOOTER = <<FOOTER
</dict>
</plist>
FOOTER


    ### XXX: Escaping code borrwed from here:
    ### http://intertwingly.net/stories/2005/09/28/xchar.rb
    ###
    ### ... but then modified to do less monkey-patching
    ###
    module XChar
      # http://intertwingly.net/stories/2004/04/14/i18n.html#CleaningWindows
      CP1252 = {
        128 => 8364, # euro sign
        130 => 8218, # single low-9 quotation mark
        131 =>  402, # latin small letter f with hook
        132 => 8222, # double low-9 quotation mark
        133 => 8230, # horizontal ellipsis
        134 => 8224, # dagger
        135 => 8225, # double dagger
        136 =>  710, # modifier letter circumflex accent
        137 => 8240, # per mille sign
        138 =>  352, # latin capital letter s with caron
        139 => 8249, # single left-pointing angle quotation mark
        140 =>  338, # latin capital ligature oe
        142 =>  381, # latin capital letter z with caron
        145 => 8216, # left single quotation mark
        146 => 8217, # right single quotation mark
        147 => 8220, # left double quotation mark
        148 => 8221, # right double quotation mark
        149 => 8226, # bullet
        150 => 8211, # en dash
        151 => 8212, # em dash
        152 =>  732, # small tilde
        153 => 8482, # trade mark sign
        154 =>  353, # latin small letter s with caron
        155 => 8250, # single right-pointing angle quotation mark
        156 =>  339, # latin small ligature oe
        158 =>  382, # latin small letter z with caron
        159 =>  376} # latin capital letter y with diaeresis

      # http://www.w3.org/TR/REC-xml/#dt-chardata
      PREDEFINED = {
        38 => '&amp;', # ampersand
        60 => '&lt;',  # left angle bracket
        62 => '&gt;'}  # right angle bracket

      # http://www.w3.org/TR/REC-xml/#charsets
      VALID = [[0x9, 0xA, 0xD], (0x20..0xD7FF), 
        (0xE000..0xFFFD), (0x10000..0x10FFFF)]
    end

    # xml escaped version of chr
    def self.xchr(char)
      n = XChar::CP1252[char] || char
      n = 42 unless XChar::VALID.find {|range| range.include? n}
      XChar::PREDEFINED[n] or (n<128 ? n.chr : "&##{n};")
    end

    # xml escaped version of to_s
    def self.xml_escape(string)
      string.unpack('U*').map {|n| xchr(n) }.join # ASCII, UTF-8
    rescue
      string.unpack('C*').map {|n| xchr(n) }.join # ISO-8859-1, WIN-1252
    end
  end
end
