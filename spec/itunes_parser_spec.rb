require 'itunes_parser'
require 'itunes_mock'

require 'minitest/autorun'

describe ItunesParser do
  before do
    @track    = {"Name" => "Test Song"}
    @playlist = {"Name" => "Test Playlist"}
    @itunes = ItunesMock.generate( :tracks => [@track], :playlists => [@playlist])
  end

  it "should parse the most basic of tracks" do
    tracks, playlists = ItunesParser.parse(@itunes)

    track = tracks.first
    track["Name"].must_equal "Test Song"
  end

  it "should parse the most basic of playlists" do
    tracks, playlists = ItunesParser.parse(@itunes)

    playlist = playlists.first
    playlist["Name"].must_equal "Test Playlist"
  end
end
