# encoding: utf-8

require 'itunes_parser'
require 'itunes_mock'

require 'minitest/autorun'

require 'stringio'

# Add tests for playlist items array
#
describe ItunesParser do
  describe "#parse" do
    before do
      @tracks     = [ { "Name"        => "Trapped", 
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

      @playlists  = [ { "Name"        => "Library",
                        "Master"      => true,
                        "Visible"     => false },
                      { "Name"        => "90’s Music" } ]
      
      @itunes = ItunesMock.generate(:tracks => @tracks, :playlists => @playlists)
      #puts @itunes
    end

    it "parses a string of xml" do
      tracks, playlists = ItunesParser.parse(@itunes)
      tracks.wont_be_empty
      playlists.wont_be_empty
    end

    it "parses an IO object" do
      tracks, playlists = ItunesParser.parse( StringIO.new(@itunes) )
      tracks.wont_be_empty
      playlists.wont_be_empty
    end

    it "parses track attributes" do
      track = ItunesParser.parse(@itunes).first.first.last
      track["Artist"].must_equal "Boards of Canada"
    end

    it "parses playlist attributes" do
      playlist = ItunesParser.parse(@itunes).last.first
      playlist["Name"].must_equal "Library"
    end

    it "parses non-ascii strings" do
      playlist = ItunesParser.parse(@itunes).last.last
      playlist["Name"].must_equal "90’s Music"
    end

    it "typecasts date strings into Time instances" do
      date = ItunesParser.parse(@itunes).first.first.last["Date Added"]
      date.must_equal Time.gm(2007, 2, 15, 20, 48, 1)
    end

    it "typecasts integer strings into Fixnums" do
      bitrate = ItunesParser.parse(@itunes).first.first.last["Bitrate"]
      bitrate.must_equal 128
    end

    it "typecasts false strings into false" do
      visible = ItunesParser.parse(@itunes).last.first["Visible"]
      visible.must_equal false
    end

    it "typecasts true strings into true" do
      explicit = ItunesParser.parse(@itunes).first.first.last["Explicit"]
      explicit.must_equal true
    end
  end

  describe ".cast_value" do
    it "parses itunes dates" do
      date = ItunesParser.cast_value('date', "2009-06-11T01:13:21Z")
      date.must_equal Time.gm(2009, 6, 11, 01, 13, 21)
    end

    it "parses 'integer' into Fixnum" do
      ItunesParser.cast_value('integer', '56').must_equal 56
    end

    it "parses 'true' into TrueClass" do
      ItunesParser.cast_value('true', nil).must_equal true
    end

    it "parses 'false' into FalseClass" do
      ItunesParser.cast_value('false', nil).must_equal false 
    end
  end
end
