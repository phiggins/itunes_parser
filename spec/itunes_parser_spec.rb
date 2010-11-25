# encoding: utf-8

require 'itunes_parser'

describe ItunesParser do
  before do
    @dummy_parser = Class.new do
      def initialize(*args) end
    end
  end

  it "allows setting the parser_class dynamically" do
    ItunesParser.parser_class.should_not == @dummy_parser
    ItunesParser.parser_class = @dummy_parser
    ItunesParser.parser_class.should == @dummy_parser
  end

  it "returns an instance of parser_class with .new" do
    ItunesParser.parser_class = @dummy_parser
    ItunesParser.new.should be_an_instance_of @dummy_parser
  end

end
