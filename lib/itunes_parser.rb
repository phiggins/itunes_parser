require 'nokogiri'

require 'itunes_parser/nokogiri_xpath'
require 'itunes_parser/nokogiri_sax'

module ItunesParser
  def self.parse(*args)
    new(*args).parse
  end

  def self.parser_class=(klass)
    @parser_class = klass
  end

  def self.parser_class
    @parser_class ||= NokogiriXpath
  end

  def self.new(*args)
    parser_class.new(*args)
  end

  VERSION = "0.1.0"
end
