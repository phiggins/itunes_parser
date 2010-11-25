require 'parser_shared'

describe ItunesParser::NokogiriSax do
  it_behaves_like "an itunes xml parser" do
    let(:parser_class) { ItunesParser::NokogiriSax }
  end
end
