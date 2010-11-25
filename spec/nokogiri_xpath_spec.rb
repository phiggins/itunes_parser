require 'parser_shared'

describe ItunesParser::NokogiriXpath do
  it_behaves_like "an itunes xml parser" do
    let(:parser_class) { ItunesParser::NokogiriXpath }
  end

  describe "a new instance" do
    before do
      xml = ItunesParser::MockXML.generate(
        :tracks     => [ {"Name" => "test track"} ],
        :playlists  => [ {"Name" => "test playlist"} ] )
      @parser = ItunesParser::NokogiriXpath.new(xml)
    end

    it "doesn't parse tracks when #playlists is called" do
      @parser.playlists
      @parser.instance_variable_get(:@tracks).should == nil
    end

    it "doesn't parse playlists when #tracks is called" do
      @parser.tracks
      @parser.instance_variable_get(:@playlists).should == nil
    end
  end
end
