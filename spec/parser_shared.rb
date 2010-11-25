# encoding: utf-8

require 'itunes_parser'
require 'itunes_parser/mock_xml'

require 'stringio'

shared_examples_for "an itunes xml parser" do
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
    
    @xml = ItunesParser::MockXML.generate(:tracks => @tracks, :playlists => @playlists)

    ItunesParser.parser_class = parser_class
  end

  it "parses a string of xml" do
    parser = ItunesParser.new(@xml)
    parser.tracks.size.should == @tracks.size
    parser.playlists.size.should == @playlists.size
  end

  it "parses an IO object" do
    parser = ItunesParser.new( StringIO.new(@xml) )
    parser.tracks.size.should == @tracks.size
    parser.playlists.size.should == @playlists.size
  end

  it "parses track attributes" do
    track = ItunesParser.new(@xml).tracks.first
    track["Artist"].should == "Boards of Canada"
  end

  it "parses playlist attributes" do
    playlist = ItunesParser.new(@xml).playlists.first
    playlist["Name"].should == "Library"
  end

  it "parses non-ascii strings" do
    playlist = ItunesParser.new(@xml).playlists.last
    playlist["Name"].should == "90’s Music"
  end

  it "typecasts false strings into false" do
    visible = ItunesParser.new(@xml).playlists.first["Visible"]
    visible.should == false
  end

  it "typecasts true strings into true" do
    explicit = ItunesParser.new(@xml).tracks.first["Explicit"]
    explicit.should == true
  end

  it "parses a playlist's 'Playlist Items' into an array of integers" do
    items = ItunesParser.new(@xml).playlists.first["Playlist Items"]
    items.should == [1,2]
  end

  it "accepts an :on_track block and calls it for each track parsed" do
    names = []
    on_track = lambda do |track|
      names << track["Name"]
    end

    ItunesParser.parse(@xml, :on_track => on_track)
    
    names.should == ["Trapped", "Fak!!!"]
  end

  it "accepts an :on_playlist block and calls it for each playlist parsed" do
    names = []
    on_playlist = lambda do |playlist|
      names << playlist["Name"]
    end

    ItunesParser.parse(@xml, :on_playlist => on_playlist)
    
    names.should == ["Library", "90’s Music"]
  end

  it "accepts an :on_playlist and :on_track block" do
    names = []
    on_playlist = lambda do |playlist|
      names << playlist["Name"]
    end

    on_track = lambda do |track|
      names << track["Name"]
    end

    ItunesParser.parse(@xml, :on_track => on_track, :on_playlist => on_playlist)
    
    names.should == ["Trapped", "Fak!!!", "Library", "90’s Music"]
  end

  it "accepts a block for #on_track and calls it for each track parsed" do
    parser = ItunesParser.new(@xml)

    names = []
    parser.on_track do |track|
      names << track["Name"]
    end

    parser.parse
    
    names.should == ["Trapped", "Fak!!!"]
  end

  it "accepts a block for #on_playlist and calls it for each playlist parsed" do
    parser = ItunesParser.new(@xml)

    names = []
    parser.on_playlist do |playlist|
      names << playlist["Name"]
    end
    
    parser.parse

    names.should == ["Library", "90’s Music"]
  end

  it "accepts a block for #on_playlist and #on_track" do
    parser = ItunesParser.new(@xml)
    
    names = []
    parser.on_playlist do |playlist|
      names << playlist["Name"]
    end

    parser.on_track do |track|
      names << track["Name"]
    end

    parser.parse

    names.should == ["Trapped", "Fak!!!", "Library", "90’s Music"]
  end

  it "doesn't store tracks or playlists when given an #on_playlist block" do
    parser = ItunesParser.new(@xml)
    
    parser.on_playlist do |playlist|
      # noop
    end

    parser.parse

    parser.tracks.should == nil
    parser.playlists.should == nil
  end

  it "doesn't store tracks or playlists when given an #on_track block" do
    parser = ItunesParser.new(@xml)
    
    parser.on_track do |track|
      #noop
    end

    parser.parse

    parser.tracks.should == nil
    parser.playlists.should == nil
  end

end
