require 'itunes_parser'
require 'itunes_mock'

require 'minitest/autorun'

describe ItunesParser do
  before do
    @itunes = ItunesMock.generate
  end

  it "should parse the most basic of things" do
    tracks, playlists = ItunesParser.parse(@itunes)

    tracks.size.must_equal 1
    playlists.size.must_equal 1
  end
end
